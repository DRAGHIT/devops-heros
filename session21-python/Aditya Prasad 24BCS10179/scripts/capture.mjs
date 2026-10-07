import {chromium} from 'playwright';
import fs from 'node:fs';
const mode=process.argv[2];
const out=`evidence/${mode}`;fs.mkdirSync(out,{recursive:true});
const browser=await chromium.launch({headless:true,args:['--no-sandbox']});
const page=await browser.newPage({viewport:{width:1440,height:1000},deviceScaleFactor:1});
for(const [name,url] of [['frontend','http://localhost:3000'],['docs','http://localhost:8000/docs'],['health','http://localhost:8000/health'],['metrics','http://localhost:8000/metrics']]){
 await page.goto(url,{waitUntil:'networkidle'});
 if(name==='frontend') await page.getByText(`${mode} PostgreSQL proof`,{exact:true}).waitFor();
 await page.screenshot({path:`${out}/${name}.png`,fullPage:true});
 console.log(`${name}: browser screenshot captured from ${url}`);
}
await browser.close();
