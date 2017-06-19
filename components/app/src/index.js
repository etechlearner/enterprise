const pathUtils = require('path');
const express = require('express');
const fs = require('fs');
const cheerio = require('cheerio');
const _ = require('lodash');

const program = require('commander');
program
  .option('-e, --env <path>', 'File path to a env file. Defaults to ../../env/app.env')
  .parse(process.argv);

const dotenv = require('dotenv');
if (program.env) {
  console.log('Loading user .env file.', program.env);
  dotenv.config({ path: program.env });
} else {
  console.log('Loading default .env file.');
  const foo = dotenv.config({ path: '../../env/app.env' });
}

const host = process.env.HOST || '127.0.0.1';
const port = process.env.PORT || 80;
const appDir = pathUtils.resolve(__dirname, 'static');

const indexHtml = fs.readFileSync(pathUtils.resolve(appDir, 'index.html'));
const $index = cheerio.load(indexHtml);
const env = _.merge(
  _.pick(process.env, 'SL_APP_HOST', 'SL_API_HOST', 'PRISM_DEV_HOST', 'PRISM_CONDUCTOR_HOST'),
  {
    ENV: 'production',
    ENTERPRISE: true,
  }
);
const envHtml = `
  <script id="envScript">
    window.__env = ${JSON.stringify(env, null, 4)};
  </script>
`;
let existingEnvScript = $index('#envScript');
if (existingEnvScript.length) {
  $index('#envScript').replaceWith(envHtml);
} else {
  $index('head').append(envHtml);
}
fs.writeFileSync(pathUtils.resolve(appDir, 'index.html'), $index.html());

const app = express();
app.use('/', express.static(appDir));
app.get('*', (req, res) => {
  res.send($index.html());
});
app.listen(port, host);

app.on('listening', () => {
  console.log(`Running app server at ${host}:${port}`);
});
