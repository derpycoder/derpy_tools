/**
 * Minified by jsDelivr using Terser v5.17.1.
 * Original file: /npm/@floating-ui/dom@1.4.3/dist/floating-ui.dom.esm.js
 *
 * Do NOT use SRI with dynamically generated files! More information: https://www.jsdelivr.com/using-sri-with-dynamic-files
 */
import{rectToClientRect,computePosition as computePosition$1}from"./floating-ui.core";export{arrow,autoPlacement,detectOverflow,flip,hide,inline,limitShift,offset,shift,size}from"./floating-ui.core";function getWindow(e){var t;return(null==(t=e.ownerDocument)?void 0:t.defaultView)||window}function getComputedStyle$1(e){return getWindow(e).getComputedStyle(e)}function isNode(e){return e instanceof getWindow(e).Node}function getNodeName(e){return isNode(e)?(e.nodeName||"").toLowerCase():"#document"}function isHTMLElement(e){return e instanceof getWindow(e).HTMLElement}function isElement(e){return e instanceof getWindow(e).Element}function isShadowRoot(e){return"undefined"!=typeof ShadowRoot&&(e instanceof getWindow(e).ShadowRoot||e instanceof ShadowRoot)}function isOverflowElement(e){const{overflow:t,overflowX:n,overflowY:o,display:i}=getComputedStyle$1(e);return/auto|scroll|overlay|hidden|clip/.test(t+o+n)&&!["inline","contents"].includes(i)}function isTableElement(e){return["table","td","th"].includes(getNodeName(e))}function isContainingBlock(e){const t=isSafari(),n=getComputedStyle$1(e);return"none"!==n.transform||"none"!==n.perspective||!!n.containerType&&"normal"!==n.containerType||!t&&!!n.backdropFilter&&"none"!==n.backdropFilter||!t&&!!n.filter&&"none"!==n.filter||["transform","perspective","filter"].some((e=>(n.willChange||"").includes(e)))||["paint","layout","strict","content"].some((e=>(n.contain||"").includes(e)))}function isSafari(){return!("undefined"==typeof CSS||!CSS.supports)&&CSS.supports("-webkit-backdrop-filter","none")}function isLastTraversableNode(e){return["html","body","#document"].includes(getNodeName(e))}const min=Math.min,max=Math.max,round=Math.round,floor=Math.floor,createEmptyCoords=e=>({x:e,y:e});function getCssDimensions(e){const t=getComputedStyle$1(e);let n=parseFloat(t.width)||0,o=parseFloat(t.height)||0;const i=isHTMLElement(e),r=i?e.offsetWidth:n,l=i?e.offsetHeight:o,s=round(n)!==r||round(o)!==l;return s&&(n=r,o=l),{width:n,height:o,$:s}}function unwrapElement(e){return isElement(e)?e:e.contextElement}function getScale(e){const t=unwrapElement(e);if(!isHTMLElement(t))return createEmptyCoords(1);const n=t.getBoundingClientRect(),{width:o,height:i,$:r}=getCssDimensions(t);let l=(r?round(n.width):n.width)/o,s=(r?round(n.height):n.height)/i;return l&&Number.isFinite(l)||(l=1),s&&Number.isFinite(s)||(s=1),{x:l,y:s}}const noOffsets=createEmptyCoords(0);function getVisualOffsets(e,t,n){var o,i;if(void 0===t&&(t=!0),!isSafari())return noOffsets;const r=e?getWindow(e):window;return!n||t&&n!==r?noOffsets:{x:(null==(o=r.visualViewport)?void 0:o.offsetLeft)||0,y:(null==(i=r.visualViewport)?void 0:i.offsetTop)||0}}function getBoundingClientRect(e,t,n,o){void 0===t&&(t=!1),void 0===n&&(n=!1);const i=e.getBoundingClientRect(),r=unwrapElement(e);let l=createEmptyCoords(1);t&&(o?isElement(o)&&(l=getScale(o)):l=getScale(e));const s=getVisualOffsets(r,n,o);let c=(i.left+s.x)/l.x,f=(i.top+s.y)/l.y,a=i.width/l.x,u=i.height/l.y;if(r){const e=getWindow(r),t=o&&isElement(o)?getWindow(o):o;let n=e.frameElement;for(;n&&o&&t!==e;){const e=getScale(n),t=n.getBoundingClientRect(),o=getComputedStyle(n),i=t.left+(n.clientLeft+parseFloat(o.paddingLeft))*e.x,r=t.top+(n.clientTop+parseFloat(o.paddingTop))*e.y;c*=e.x,f*=e.y,a*=e.x,u*=e.y,c+=i,f+=r,n=getWindow(n).frameElement}}return rectToClientRect({width:a,height:u,x:c,y:f})}function getDocumentElement(e){return((isNode(e)?e.ownerDocument:e.document)||window.document).documentElement}function getNodeScroll(e){return isElement(e)?{scrollLeft:e.scrollLeft,scrollTop:e.scrollTop}:{scrollLeft:e.pageXOffset,scrollTop:e.pageYOffset}}function convertOffsetParentRelativeRectToViewportRelativeRect(e){let{rect:t,offsetParent:n,strategy:o}=e;const i=isHTMLElement(n),r=getDocumentElement(n);if(n===r)return t;let l={scrollLeft:0,scrollTop:0},s=createEmptyCoords(1);const c=createEmptyCoords(0);if((i||!i&&"fixed"!==o)&&(("body"!==getNodeName(n)||isOverflowElement(r))&&(l=getNodeScroll(n)),isHTMLElement(n))){const e=getBoundingClientRect(n);s=getScale(n),c.x=e.x+n.clientLeft,c.y=e.y+n.clientTop}return{width:t.width*s.x,height:t.height*s.y,x:t.x*s.x-l.scrollLeft*s.x+c.x,y:t.y*s.y-l.scrollTop*s.y+c.y}}function getWindowScrollBarX(e){return getBoundingClientRect(getDocumentElement(e)).left+getNodeScroll(e).scrollLeft}function getDocumentRect(e){const t=getDocumentElement(e),n=getNodeScroll(e),o=e.ownerDocument.body,i=max(t.scrollWidth,t.clientWidth,o.scrollWidth,o.clientWidth),r=max(t.scrollHeight,t.clientHeight,o.scrollHeight,o.clientHeight);let l=-n.scrollLeft+getWindowScrollBarX(e);const s=-n.scrollTop;return"rtl"===getComputedStyle$1(o).direction&&(l+=max(t.clientWidth,o.clientWidth)-i),{width:i,height:r,x:l,y:s}}function getParentNode(e){if("html"===getNodeName(e))return e;const t=e.assignedSlot||e.parentNode||isShadowRoot(e)&&e.host||getDocumentElement(e);return isShadowRoot(t)?t.host:t}function getNearestOverflowAncestor(e){const t=getParentNode(e);return isLastTraversableNode(t)?e.ownerDocument?e.ownerDocument.body:e.body:isHTMLElement(t)&&isOverflowElement(t)?t:getNearestOverflowAncestor(t)}function getOverflowAncestors(e,t){var n;void 0===t&&(t=[]);const o=getNearestOverflowAncestor(e),i=o===(null==(n=e.ownerDocument)?void 0:n.body),r=getWindow(o);return i?t.concat(r,r.visualViewport||[],isOverflowElement(o)?o:[]):t.concat(o,getOverflowAncestors(o))}function getViewportRect(e,t){const n=getWindow(e),o=getDocumentElement(e),i=n.visualViewport;let r=o.clientWidth,l=o.clientHeight,s=0,c=0;if(i){r=i.width,l=i.height;const e=isSafari();(!e||e&&"fixed"===t)&&(s=i.offsetLeft,c=i.offsetTop)}return{width:r,height:l,x:s,y:c}}function getInnerBoundingClientRect(e,t){const n=getBoundingClientRect(e,!0,"fixed"===t),o=n.top+e.clientTop,i=n.left+e.clientLeft,r=isHTMLElement(e)?getScale(e):createEmptyCoords(1);return{width:e.clientWidth*r.x,height:e.clientHeight*r.y,x:i*r.x,y:o*r.y}}function getClientRectFromClippingAncestor(e,t,n){let o;if("viewport"===t)o=getViewportRect(e,n);else if("document"===t)o=getDocumentRect(getDocumentElement(e));else if(isElement(t))o=getInnerBoundingClientRect(t,n);else{const n=getVisualOffsets(e);o={...t,x:t.x-n.x,y:t.y-n.y}}return rectToClientRect(o)}function hasFixedPositionAncestor(e,t){const n=getParentNode(e);return!(n===t||!isElement(n)||isLastTraversableNode(n))&&("fixed"===getComputedStyle$1(n).position||hasFixedPositionAncestor(n,t))}function getClippingElementAncestors(e,t){const n=t.get(e);if(n)return n;let o=getOverflowAncestors(e).filter((e=>isElement(e)&&"body"!==getNodeName(e))),i=null;const r="fixed"===getComputedStyle$1(e).position;let l=r?getParentNode(e):e;for(;isElement(l)&&!isLastTraversableNode(l);){const t=getComputedStyle$1(l),n=isContainingBlock(l);n||"fixed"!==t.position||(i=null);(r?!n&&!i:!n&&"static"===t.position&&!!i&&["absolute","fixed"].includes(i.position)||isOverflowElement(l)&&!n&&hasFixedPositionAncestor(e,l))?o=o.filter((e=>e!==l)):i=t,l=getParentNode(l)}return t.set(e,o),o}function getClippingRect(e){let{element:t,boundary:n,rootBoundary:o,strategy:i}=e;const r=[..."clippingAncestors"===n?getClippingElementAncestors(t,this._c):[].concat(n),o],l=r[0],s=r.reduce(((e,n)=>{const o=getClientRectFromClippingAncestor(t,n,i);return e.top=max(o.top,e.top),e.right=min(o.right,e.right),e.bottom=min(o.bottom,e.bottom),e.left=max(o.left,e.left),e}),getClientRectFromClippingAncestor(t,l,i));return{width:s.right-s.left,height:s.bottom-s.top,x:s.left,y:s.top}}function getDimensions(e){return getCssDimensions(e)}function getTrueOffsetParent(e,t){return isHTMLElement(e)&&"fixed"!==getComputedStyle$1(e).position?t?t(e):e.offsetParent:null}function getContainingBlock(e){let t=getParentNode(e);for(;isHTMLElement(t)&&!isLastTraversableNode(t);){if(isContainingBlock(t))return t;t=getParentNode(t)}return null}function getOffsetParent(e,t){const n=getWindow(e);if(!isHTMLElement(e))return n;let o=getTrueOffsetParent(e,t);for(;o&&isTableElement(o)&&"static"===getComputedStyle$1(o).position;)o=getTrueOffsetParent(o,t);return o&&("html"===getNodeName(o)||"body"===getNodeName(o)&&"static"===getComputedStyle$1(o).position&&!isContainingBlock(o))?n:o||getContainingBlock(e)||n}function getRectRelativeToOffsetParent(e,t,n){const o=isHTMLElement(t),i=getDocumentElement(t),r="fixed"===n,l=getBoundingClientRect(e,!0,r,t);let s={scrollLeft:0,scrollTop:0};const c=createEmptyCoords(0);if(o||!o&&!r)if(("body"!==getNodeName(t)||isOverflowElement(i))&&(s=getNodeScroll(t)),isHTMLElement(t)){const e=getBoundingClientRect(t,!0,r,t);c.x=e.x+t.clientLeft,c.y=e.y+t.clientTop}else i&&(c.x=getWindowScrollBarX(i));return{x:l.left+s.scrollLeft-c.x,y:l.top+s.scrollTop-c.y,width:l.width,height:l.height}}const platform={getClippingRect:getClippingRect,convertOffsetParentRelativeRectToViewportRelativeRect:convertOffsetParentRelativeRectToViewportRelativeRect,isElement:isElement,getDimensions:getDimensions,getOffsetParent:getOffsetParent,getDocumentElement:getDocumentElement,getScale:getScale,async getElementRects(e){let{reference:t,floating:n,strategy:o}=e;const i=this.getOffsetParent||getOffsetParent,r=this.getDimensions;return{reference:getRectRelativeToOffsetParent(t,await i(n),o),floating:{x:0,y:0,...await r(n)}}},getClientRects:e=>Array.from(e.getClientRects()),isRTL:e=>"rtl"===getComputedStyle$1(e).direction};function observeMove(e,t){let n,o=null;const i=getDocumentElement(e);function r(){clearTimeout(n),o&&o.disconnect(),o=null}return function l(s,c){void 0===s&&(s=!1),void 0===c&&(c=1),r();const{left:f,top:a,width:u,height:g}=e.getBoundingClientRect();if(s||t(),!u||!g)return;const d={rootMargin:-floor(a)+"px "+-floor(i.clientWidth-(f+u))+"px "+-floor(i.clientHeight-(a+g))+"px "+-floor(f)+"px",threshold:max(0,min(1,c))||1};let m=!0;function p(e){const t=e[0].intersectionRatio;if(t!==c){if(!m)return l();t?l(!1,t):n=setTimeout((()=>{l(!1,1e-7)}),100)}m=!1}try{o=new IntersectionObserver(p,{...d,root:i.ownerDocument})}catch(e){o=new IntersectionObserver(p,d)}o.observe(e)}(!0),r}function autoUpdate(e,t,n,o){void 0===o&&(o={});const{ancestorScroll:i=!0,ancestorResize:r=!0,elementResize:l="function"==typeof ResizeObserver,layoutShift:s="function"==typeof IntersectionObserver,animationFrame:c=!1}=o,f=unwrapElement(e),a=i||r?[...f?getOverflowAncestors(f):[],...getOverflowAncestors(t)]:[];a.forEach((e=>{i&&e.addEventListener("scroll",n,{passive:!0}),r&&e.addEventListener("resize",n)}));const u=f&&s?observeMove(f,n):null;let g,d=-1,m=null;l&&(m=new ResizeObserver((e=>{let[o]=e;o&&o.target===f&&m&&(m.unobserve(t),cancelAnimationFrame(d),d=requestAnimationFrame((()=>{m&&m.observe(t)}))),n()})),f&&!c&&m.observe(f),m.observe(t));let p=c?getBoundingClientRect(e):null;return c&&function t(){const o=getBoundingClientRect(e);!p||o.x===p.x&&o.y===p.y&&o.width===p.width&&o.height===p.height||n();p=o,g=requestAnimationFrame(t)}(),n(),()=>{a.forEach((e=>{i&&e.removeEventListener("scroll",n),r&&e.removeEventListener("resize",n)})),u&&u(),m&&m.disconnect(),m=null,c&&cancelAnimationFrame(g)}}const computePosition=(e,t,n)=>{const o=new Map,i={platform:platform,...n},r={...i.platform,_c:o};return computePosition$1(e,t,{...i,platform:r})};export{autoUpdate,computePosition,getOverflowAncestors,platform};
//# sourceMappingURL=/sm/92a65810749057fca533ea769e9feed27b92bea04d67ba5bb18a58a734e7025b.map