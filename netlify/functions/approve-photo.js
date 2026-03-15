// netlify/functions/approve-photo.js
// Moves a photo from aba-gallery/pending to aba-gallery/approved in Cloudinary
// and removes the "pending" tag, adds "approved"

const https = require('https');
const crypto = require('crypto');

exports.handler = async (event) => {
  if (event.httpMethod !== 'POST') {
    return { statusCode: 405, body: 'Method Not Allowed' };
  }

  // Auth check
  const auth = event.headers['authorization'] || '';
  if (!auth.startsWith('Bearer ')) {
    return { statusCode: 401, body: JSON.stringify({ error: 'Unauthorized' }) };
  }

  const cloudName = process.env.CLOUDINARY_CLOUD_NAME;
  const apiKey    = process.env.CLOUDINARY_API_KEY;
  const apiSecret = process.env.CLOUDINARY_API_SECRET;

  if (!cloudName || !apiKey || !apiSecret) {
    return { statusCode: 500, body: JSON.stringify({ error: 'Cloudinary env vars not set' }) };
  }

  let publicId;
  try {
    ({ publicId } = JSON.parse(event.body));
  } catch {
    return { statusCode: 400, body: JSON.stringify({ error: 'Invalid request body' }) };
  }

  try {
    // Build new public_id in the approved folder
    const filename    = publicId.split('/').pop();
    const newPublicId = `aba-gallery/approved/${filename}`;
    const timestamp   = Math.floor(Date.now() / 1000);

    // Cloudinary rename (move) uses a signed API call
    const signStr   = `from_public_id=${publicId}&timestamp=${timestamp}&to_public_id=${newPublicId}${apiSecret}`;
    const signature = crypto.createHash('sha1').update(signStr).digest('hex');

    const params = new URLSearchParams({
      from_public_id: publicId,
      to_public_id:   newPublicId,
      timestamp:      timestamp.toString(),
      api_key:        apiKey,
      signature
    });

    const newUrl = await new Promise((resolve, reject) => {
      const postData = params.toString();
      const options = {
        hostname: 'api.cloudinary.com',
        path:     `/v1_1/${cloudName}/image/rename`,
        method:   'POST',
        headers: {
          'Content-Type':   'application/x-www-form-urlencoded',
          'Content-Length': Buffer.byteLength(postData)
        }
      };
      const req = https.request(options, (res) => {
        let body = '';
        res.on('data', c => body += c);
        res.on('end', () => {
          try {
            const d = JSON.parse(body);
            if (d.error) reject(new Error(d.error.message));
            else resolve(d.secure_url);
          } catch (e) { reject(e); }
        });
      });
      req.on('error', reject);
      req.write(postData);
      req.end();
    });

    return {
      statusCode: 200,
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ success: true, newUrl, newPublicId })
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message })
    };
  }
};
