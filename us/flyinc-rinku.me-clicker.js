// ==UserScript==
// @name         Fly Inc Rinku.me Clicker
// @author       rinr1nrin
// @namespace    https://codeberg.org/rinr1nrin/Fly_Inc_Rinku.me_Clicker
// @updateURL    https://codeberg.org/rinr1nrin/Fly_Inc_Rinku.me_Clicker/raw/branch/master/Fly_Inc_Rinku.me_Clicker.user.js
// @downloadURL  https://codeberg.org/rinr1nrin/Fly_Inc_Rinku.me_Clicker/raw/branch/master/Fly_Inc_Rinku.me_Clicker.user.js
// @version      1.6
// @description  Autoclicker for Fly links
// @icon         https://rinku.me/favicon.ico
// @match        https://*/*
// @run-at       document-idle
// ==/UserScript==
!function(){"use strict";let e=[...document.scripts].some(e=>e.src.includes("https://cdn.adapex.io/hb/aaw.esladvice.js")||e.src.includes("https://securepubads.g.doubleclick.net/tag/js/gpt.js")),t=[...document.querySelectorAll("style")].some(e=>e.textContent.includes("card-container")&&e.textContent.includes("top-card")&&e.textContent.includes("card")&&e.textContent.includes("step")&&e.textContent.includes("menu")&&e.textContent.includes("navigation")&&e.textContent.includes("menu-btn")),n=[...document.scripts].some(e=>e.src.includes("https://static.cloudflareinsights.com/beacon.min.js")),c=!!document.querySelector(".card-container .top-card .menu .logo");if(!e||!t||!n||!c){"adslift.xyz"===window.location.hostname&&window.location.pathname.includes("/land/")&&(i(),setTimeout(e=>clearInterval(e),1e4,setInterval(i,10)),s(),setTimeout(e=>clearInterval(e),1e4,setInterval(s,10)),d(),u(),$(),p(),triggerContinue());let l=[];e||l.push("Ad script missing"),t||l.push("Card styles missing"),n||l.push("Cloudflare script missing"),c||l.push("Required DOM classes missing"),l.length&&console.log("===== Fly Inc Rinku.me Clicker =====\nCheck fail: "+window.location.href+"\n\n"+l.join("\n"));return}function i(){let e=document.getElementById("delulu-overlay");e&&(e.style.display="none")}function s(){let e=document.getElementById("adOverlay");e&&(e.style.display="none")}function o(){let e=[...document.querySelectorAll('[class^="btn-"],[src*="/recaptcha/"],#captcha-container,#click,#redirect-link,#switchCaptcha')],t=new Set;e.forEach(e=>{t.add(e);let n=e.parentElement;for(;n;)t.add(n),n=n.parentElement;e.querySelectorAll("*").forEach(e=>t.add(e))}),[...document.querySelectorAll("*")].forEach(e=>{t.has(e)||(e.style.display="none")})}function a(){window.dispatchEvent(new Event("scroll"))}function r(){let e=!1;for(let t=0;t<3;t++){let n="mustClickAd"+t;"1"===sessionStorage.getItem(n)&&(e=!0),sessionStorage.setItem(n,"0")}e&&window.location.replace(window.location.href)}function d(){document.body.appendChild(Object.assign(document.createElement("script"),{textContent:"redirectToErrorPage = function () { };"}))}function u(){document.body.appendChild(Object.assign(document.createElement("script"),{textContent:"detectIncognito = function () { };"}))}function $(){document.body.appendChild(Object.assign(document.createElement("script"),{textContent:"isAdblockActive = function () { };"}))}function p(){document.body.appendChild(Object.assign(document.createElement("script"),{textContent:"isVpnActive = function () { };"}))}function m(){let e=document.querySelector('button[class*="btn-"]');e&&!e.disabled&&"none"!==getComputedStyle(e.parentElement.parentElement).display&&e.click()}function h(){let e=document.querySelector('button[class*="btn-"]');e&&(e.parentElement.parentElement.style.display="block",e.disabled=!1)}i(),setTimeout(e=>clearInterval(e),1e4,setInterval(i,10)),s(),setTimeout(e=>clearInterval(e),1e4,setInterval(s,10)),o(),setTimeout(e=>clearInterval(e),1e4,setInterval(o,100)),a(),setTimeout(e=>clearInterval(e),1e4,setInterval(a,100)),r(),setTimeout(e=>clearInterval(e),1e4,setInterval(r,100)),d(),u(),$(),p(),m(),new MutationObserver(m).observe(document.body,{childList:!0,subtree:!0,attributes:!0,attributeFilter:["disabled"]}),setTimeout(()=>{setInterval(h,10)},1e4)}();


/* --------------------------------------------- DISABLE FOCUS WINDOW ------------------------------------------------------------------------------------------------------- */
let events_to_block = [
  "visibilitychange",
  "webkitvisibilitychange",
  "mozvisibilitychange",
  "hasFocus",
  "blur",
  "focus",
  "mouseleave"
]

for (let event_name of events_to_block) {
  document.addEventListener(event_name, function (event) {
      event.preventDefault();
      event.stopPropagation();
      event.stopImmediatePropagation();
  }, true);
}

for (let event_name of events_to_block) {
  window.addEventListener(event_name, function (event) {
      event.preventDefault();
      event.stopPropagation();
      event.stopImmediatePropagation();
  }, true);
}


document.hasFocus = function () { return true; };
document.onvisibilitychange = null;
Object.defineProperty(document, "visibilityState", { value: "visible" });
Object.defineProperty(document, "hidden", { value: false });
Object.defineProperty(document, "mozHidden", { value: false });
Object.defineProperty(document, "webkitHidden", { value: false });
Object.defineProperty(document, "webkitVisibilityState", { value: "visible" });

/* ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------*/
