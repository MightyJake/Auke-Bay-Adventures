// netlify/functions/reject-photo.js
// Permanently deletes a photo from Cloudinary (used when admin rejects a submission)

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
    const timestamp = Math.floor(Date.now() / 1000);
    const signStr   = `public_id=${publicId}&timestamp=${timestamp}${apiSecret}`;
    const signature = crypto.createHash('sha1').update(signStr).digest('hex');

    const params = new URLSearchParams({
      public_id: publicId,
      timestamp: timestamp.toString(),
      api_key:   apiKey,
      signature
    });

    await new Promise((resolve, reject) => {
      const postData = params.toString();
      const options = {
        hostname: 'api.cloudinary.com',
        path:     `/v1_1/${cloudName}/image/destroy`,
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
            if (d.result === 'ok' || d.result === 'not found') resolve(d);
            else reject(new Error(d.error?.message || 'Delete failed'));
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
      body: JSON.stringify({ success: true })
    };
  } catch (err) {
    return {
      statusCode: 500,
      body: JSON.stringify({ error: err.message })
    };
  }
};
