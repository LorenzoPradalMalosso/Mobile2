const http = require('node:http');
const crypto = require('node:crypto');
const fs = require('node:fs');
const path = require('node:path');

const port = Number(process.env.PORT || 3000);
const dataFile = path.join(__dirname, 'data.json');
const sessions = new Map();

function readData() {
  try { return JSON.parse(fs.readFileSync(dataFile, 'utf8')); }
  catch (error) {
    if (error.code === 'ENOENT') return { users: [], punches: [] };
    throw error;
  }
}
function writeData(data) {
  fs.mkdirSync(path.dirname(dataFile), { recursive: true });
  fs.writeFileSync(dataFile, JSON.stringify(data, null, 2));
}
function json(res, status, value) {
  res.writeHead(status, { 'Content-Type': 'application/json; charset=utf-8' });
  res.end(JSON.stringify(value));
}
function readBody(req) {
  return new Promise((resolve, reject) => {
    let body = '';
    req.on('data', chunk => { body += chunk; if (body.length > 1_000_000) reject(new Error('Corpo muito grande')); });
    req.on('end', () => {
      try { resolve(JSON.parse(body || '{}')); }
      catch { reject(new Error('JSON inválido')); }
    });
    req.on('error', reject);
  });
}
function passwordHash(password, salt) {
  return crypto.scryptSync(password, salt, 64).toString('hex');
}
function getUser(req, data) {
  const token = (req.headers.authorization || '').replace(/^Bearer\s+/i, '');
  const userId = sessions.get(token);
  return data.users.find(user => user.id === userId);
}
function authenticate(user, password) {
  if (!user || typeof password !== 'string') return false;
  const actual = Buffer.from(passwordHash(password, user.salt), 'hex');
  const expected = Buffer.from(user.passwordHash, 'hex');
  return actual.length === expected.length && crypto.timingSafeEqual(actual, expected);
}

const server = http.createServer(async (req, res) => {
  try {
    const url = new URL(req.url, `http://${req.headers.host || 'localhost'}`);
    const data = readData();
    if (req.method === 'GET' && url.pathname === '/api/health') return json(res, 200, { status: 'ok' });

    if (req.method === 'POST' && ['/api/auth/register', '/api/auth/login'].includes(url.pathname)) {
      const body = await readBody(req);
      const identifier = String(body.identifier || body.email || '').trim().toLowerCase();
      const password = body.password;
      if (!identifier || typeof password !== 'string' || password.length < 6)
        return json(res, 400, { message: 'Informe um NIF/e-mail e senha (mínimo 6 caracteres).' });

      let user = data.users.find(item => item.identifier === identifier);
      if (url.pathname.endsWith('/register')) {
        if (user) return json(res, 409, { message: 'Já existe uma conta com este NIF/e-mail.' });
        const salt = crypto.randomBytes(16).toString('hex');
        user = { id: crypto.randomUUID(), identifier, email: body.email || null, salt, passwordHash: passwordHash(password, salt) };
        data.users.push(user);
        writeData(data);
      } else if (!authenticate(user, password)) {
        return json(res, 401, { message: 'NIF/e-mail ou senha incorretos.' });
      }
      const token = crypto.randomBytes(32).toString('hex');
      sessions.set(token, user.id);
      return json(res, url.pathname.endsWith('/register') ? 201 : 200, {
        token,
        user: { id: user.id, identifier: user.identifier, email: user.email },
      });
    }

    const user = getUser(req, data);
    if (!user) return json(res, 401, { message: 'Sessão inválida. Entre novamente.' });

    if (req.method === 'GET' && url.pathname === '/api/punches') {
      const records = data.punches.filter(item => item.user_id === user.id)
        .sort((a, b) => b.at.localeCompare(a.at)).slice(0, 100);
      return json(res, 200, { records });
    }
    if (req.method === 'POST' && url.pathname === '/api/punches') {
      const body = await readBody(req);
      const latitude = Number(body.latitude);
      const longitude = Number(body.longitude);
      if (!['Entrada', 'Saída'].includes(body.type) || !Number.isFinite(latitude) || !Number.isFinite(longitude))
        return json(res, 400, { message: 'Dados do ponto inválidos.' });
      const record = {
        id: crypto.randomUUID(), user_id: user.id, type: body.type,
        at: body.at || new Date().toISOString(), latitude, longitude,
        distance_meters: Number(body.distance_meters) || 0,
        note: String(body.note || ''),
      };
      data.punches.push(record);
      writeData(data);
      return json(res, 201, { record });
    }
    return json(res, 404, { message: 'Endpoint não encontrado.' });
  } catch (error) {
    console.error(error);
    return json(res, 400, { message: error.message || 'Requisição inválida.' });
  }
});

server.listen(port, '0.0.0.0', () => {
  console.log(`Ponto Seguro API ouvindo em http://0.0.0.0:${port}/api`);
});
