import {chromium} from 'playwright';import fs from 'node:fs';
const mode=process.argv[2];const root=`evidence/${mode}`;
const escape=s=>s.replaceAll('&','&amp;').replaceAll('<','&lt;').replaceAll('>','&gt;');
const browser=await chromium.launch({args:['--no-sandbox']});
const page=await browser.newPage({viewport:{width:1440,height:1100},deviceScaleFactor:1});
for(const name of ['api-tests','database','pytest','runtime','build','cleanup','backend','frontend']){
 const file=`${root}/${name}.log`;if(!fs.existsSync(file))continue;
 const text=fs.readFileSync(file,'utf8');
 let lines=text.split('\n');if(lines.length>100)lines=['[Long build output: final 100 lines shown; full raw log is linked in README.]',...lines.slice(-100)];
 await page.setContent(`<html><head><style>body{margin:24px;background:#0e1625;color:#e5eef8;font:17px monospace}h1{font:26px sans-serif;color:#80d4ff}pre{white-space:pre-wrap;overflow-wrap:anywhere;line-height:1.4}</style></head><body><h1>Session 21 - ${mode} - ${name}</h1><p>Actual captured command output, rendered for readable evidence (not a terminal screenshot).</p><pre>${escape(lines.join('\n'))}</pre></body></html>`);
 await page.screenshot({path:`${root}/${["backend","frontend"].includes(name)?name+"-output":name}.png`,fullPage:true});
}
await browser.close();
