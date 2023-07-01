/**
 * Minified by jsDelivr using Terser v5.17.1.
 * Original file: /npm/@floating-ui/core@1.3.1/dist/floating-ui.core.esm.js
 *
 * Do NOT use SRI with dynamically generated files! More information: https://www.jsdelivr.com/using-sri-with-dynamic-files
 */
function getAlignment(e){return e.split("-")[1]}function getLengthFromAxis(e){return"y"===e?"height":"width"}function getSide(e){return e.split("-")[0]}function getMainAxisFromPlacement(e){return["top","bottom"].includes(getSide(e))?"x":"y"}function computeCoordsFromPlacement(e,t,n){let{reference:i,floating:o}=e;const r=i.x+i.width/2-o.width/2,a=i.y+i.height/2-o.height/2,l=getMainAxisFromPlacement(t),s=getLengthFromAxis(l),c=i[s]/2-o[s]/2,f="x"===l;let m;switch(getSide(t)){case"top":m={x:r,y:i.y-o.height};break;case"bottom":m={x:r,y:i.y+i.height};break;case"right":m={x:i.x+i.width,y:a};break;case"left":m={x:i.x-o.width,y:a};break;default:m={x:i.x,y:i.y}}switch(getAlignment(t)){case"start":m[l]-=c*(n&&f?-1:1);break;case"end":m[l]+=c*(n&&f?-1:1)}return m}const computePosition=async(e,t,n)=>{const{placement:i="bottom",strategy:o="absolute",middleware:r=[],platform:a}=n,l=r.filter(Boolean),s=await(null==a.isRTL?void 0:a.isRTL(t));let c=await a.getElementRects({reference:e,floating:t,strategy:o}),{x:f,y:m}=computeCoordsFromPlacement(c,i,s),g=i,d={},u=0;for(let n=0;n<l.length;n++){const{name:r,fn:p}=l[n],{x:h,y:x,data:y,reset:w}=await p({x:f,y:m,initialPlacement:i,placement:g,strategy:o,middlewareData:d,rects:c,platform:a,elements:{reference:e,floating:t}});f=null!=h?h:f,m=null!=x?x:m,d={...d,[r]:{...d[r],...y}},w&&u<=50&&(u++,"object"==typeof w&&(w.placement&&(g=w.placement),w.rects&&(c=!0===w.rects?await a.getElementRects({reference:e,floating:t,strategy:o}):w.rects),({x:f,y:m}=computeCoordsFromPlacement(c,g,s))),n=-1)}return{x:f,y:m,placement:g,strategy:o,middlewareData:d}};function evaluate(e,t){return"function"==typeof e?e(t):e}function expandPaddingObject(e){return{top:0,right:0,bottom:0,left:0,...e}}function getSideObjectFromPadding(e){return"number"!=typeof e?expandPaddingObject(e):{top:e,right:e,bottom:e,left:e}}function rectToClientRect(e){return{...e,top:e.y,left:e.x,right:e.x+e.width,bottom:e.y+e.height}}async function detectOverflow(e,t){var n;void 0===t&&(t={});const{x:i,y:o,platform:r,rects:a,elements:l,strategy:s}=e,{boundary:c="clippingAncestors",rootBoundary:f="viewport",elementContext:m="floating",altBoundary:g=!1,padding:d=0}=evaluate(t,e),u=getSideObjectFromPadding(d),p=l[g?"floating"===m?"reference":"floating":m],h=rectToClientRect(await r.getClippingRect({element:null==(n=await(null==r.isElement?void 0:r.isElement(p)))||n?p:p.contextElement||await(null==r.getDocumentElement?void 0:r.getDocumentElement(l.floating)),boundary:c,rootBoundary:f,strategy:s})),x="floating"===m?{...a.floating,x:i,y:o}:a.reference,y=await(null==r.getOffsetParent?void 0:r.getOffsetParent(l.floating)),w=await(null==r.isElement?void 0:r.isElement(y))&&await(null==r.getScale?void 0:r.getScale(y))||{x:1,y:1},v=rectToClientRect(r.convertOffsetParentRelativeRectToViewportRelativeRect?await r.convertOffsetParentRelativeRectToViewportRelativeRect({rect:x,offsetParent:y,strategy:s}):x);return{top:(h.top-v.top+u.top)/w.y,bottom:(v.bottom-h.bottom+u.bottom)/w.y,left:(h.left-v.left+u.left)/w.x,right:(v.right-h.right+u.right)/w.x}}const min=Math.min,max=Math.max;function within(e,t,n){return max(e,min(t,n))}const arrow=e=>({name:"arrow",options:e,async fn(t){const{x:n,y:i,placement:o,rects:r,platform:a,elements:l}=t,{element:s,padding:c=0}=evaluate(e,t)||{};if(null==s)return{};const f=getSideObjectFromPadding(c),m={x:n,y:i},g=getMainAxisFromPlacement(o),d=getLengthFromAxis(g),u=await a.getDimensions(s),p="y"===g,h=p?"top":"left",x=p?"bottom":"right",y=p?"clientHeight":"clientWidth",w=r.reference[d]+r.reference[g]-m[g]-r.floating[d],v=m[g]-r.reference[g],A=await(null==a.getOffsetParent?void 0:a.getOffsetParent(s));let b=A?A[y]:0;b&&await(null==a.isElement?void 0:a.isElement(A))||(b=l.floating[y]||r.floating[d]);const P=w/2-v/2,O=b/2-u[d]/2-1,S=min(f[h],O),R=min(f[x],O),F=S,C=b-u[d]-R,L=b/2-u[d]/2+P,T=within(F,L,C),M=null!=getAlignment(o)&&L!=T&&r.reference[d]/2-(L<F?S:R)-u[d]/2<0?L<F?F-L:C-L:0;return{[g]:m[g]-M,data:{[g]:T,centerOffset:L-T+M}}}}),sides=["top","right","bottom","left"],allPlacements=sides.reduce(((e,t)=>e.concat(t,t+"-start",t+"-end")),[]),oppositeSideMap={left:"right",right:"left",bottom:"top",top:"bottom"};function getOppositePlacement(e){return e.replace(/left|right|bottom|top/g,(e=>oppositeSideMap[e]))}function getAlignmentSides(e,t,n){void 0===n&&(n=!1);const i=getAlignment(e),o=getMainAxisFromPlacement(e),r=getLengthFromAxis(o);let a="x"===o?i===(n?"end":"start")?"right":"left":"start"===i?"bottom":"top";return t.reference[r]>t.floating[r]&&(a=getOppositePlacement(a)),{main:a,cross:getOppositePlacement(a)}}const oppositeAlignmentMap={start:"end",end:"start"};function getOppositeAlignmentPlacement(e){return e.replace(/start|end/g,(e=>oppositeAlignmentMap[e]))}function getPlacementList(e,t,n){return(e?[...n.filter((t=>getAlignment(t)===e)),...n.filter((t=>getAlignment(t)!==e))]:n.filter((e=>getSide(e)===e))).filter((n=>!e||(getAlignment(n)===e||!!t&&getOppositeAlignmentPlacement(n)!==n)))}const autoPlacement=function(e){return void 0===e&&(e={}),{name:"autoPlacement",options:e,async fn(t){var n,i,o;const{rects:r,middlewareData:a,placement:l,platform:s,elements:c}=t,{crossAxis:f=!1,alignment:m,allowedPlacements:g=allPlacements,autoAlignment:d=!0,...u}=evaluate(e,t),p=void 0!==m||g===allPlacements?getPlacementList(m||null,d,g):g,h=await detectOverflow(t,u),x=(null==(n=a.autoPlacement)?void 0:n.index)||0,y=p[x];if(null==y)return{};const{main:w,cross:v}=getAlignmentSides(y,r,await(null==s.isRTL?void 0:s.isRTL(c.floating)));if(l!==y)return{reset:{placement:p[0]}};const A=[h[getSide(y)],h[w],h[v]],b=[...(null==(i=a.autoPlacement)?void 0:i.overflows)||[],{placement:y,overflows:A}],P=p[x+1];if(P)return{data:{index:x+1,overflows:b},reset:{placement:P}};const O=b.map((e=>{const t=getAlignment(e.placement);return[e.placement,t&&f?e.overflows.slice(0,2).reduce(((e,t)=>e+t),0):e.overflows[0],e.overflows]})).sort(((e,t)=>e[1]-t[1])),S=(null==(o=O.filter((e=>e[2].slice(0,getAlignment(e[0])?2:3).every((e=>e<=0))))[0])?void 0:o[0])||O[0][0];return S!==l?{data:{index:x+1,overflows:b},reset:{placement:S}}:{}}}};function getExpandedPlacements(e){const t=getOppositePlacement(e);return[getOppositeAlignmentPlacement(e),t,getOppositeAlignmentPlacement(t)]}function getSideList(e,t,n){const i=["left","right"],o=["right","left"],r=["top","bottom"],a=["bottom","top"];switch(e){case"top":case"bottom":return n?t?o:i:t?i:o;case"left":case"right":return t?r:a;default:return[]}}function getOppositeAxisPlacements(e,t,n,i){const o=getAlignment(e);let r=getSideList(getSide(e),"start"===n,i);return o&&(r=r.map((e=>e+"-"+o)),t&&(r=r.concat(r.map(getOppositeAlignmentPlacement)))),r}const flip=function(e){return void 0===e&&(e={}),{name:"flip",options:e,async fn(t){var n;const{placement:i,middlewareData:o,rects:r,initialPlacement:a,platform:l,elements:s}=t,{mainAxis:c=!0,crossAxis:f=!0,fallbackPlacements:m,fallbackStrategy:g="bestFit",fallbackAxisSideDirection:d="none",flipAlignment:u=!0,...p}=evaluate(e,t),h=getSide(i),x=getSide(a)===a,y=await(null==l.isRTL?void 0:l.isRTL(s.floating)),w=m||(x||!u?[getOppositePlacement(a)]:getExpandedPlacements(a));m||"none"===d||w.push(...getOppositeAxisPlacements(a,u,d,y));const v=[a,...w],A=await detectOverflow(t,p),b=[];let P=(null==(n=o.flip)?void 0:n.overflows)||[];if(c&&b.push(A[h]),f){const{main:e,cross:t}=getAlignmentSides(i,r,y);b.push(A[e],A[t])}if(P=[...P,{placement:i,overflows:b}],!b.every((e=>e<=0))){var O,S;const e=((null==(O=o.flip)?void 0:O.index)||0)+1,t=v[e];if(t)return{data:{index:e,overflows:P},reset:{placement:t}};let n=null==(S=P.filter((e=>e.overflows[0]<=0)).sort(((e,t)=>e.overflows[1]-t.overflows[1]))[0])?void 0:S.placement;if(!n)switch(g){case"bestFit":{var R;const e=null==(R=P.map((e=>[e.placement,e.overflows.filter((e=>e>0)).reduce(((e,t)=>e+t),0)])).sort(((e,t)=>e[1]-t[1]))[0])?void 0:R[0];e&&(n=e);break}case"initialPlacement":n=a}if(i!==n)return{reset:{placement:n}}}return{}}}};function getSideOffsets(e,t){return{top:e.top-t.height,right:e.right-t.width,bottom:e.bottom-t.height,left:e.left-t.width}}function isAnySideFullyClipped(e){return sides.some((t=>e[t]>=0))}const hide=function(e){return void 0===e&&(e={}),{name:"hide",options:e,async fn(t){const{rects:n}=t,{strategy:i="referenceHidden",...o}=evaluate(e,t);switch(i){case"referenceHidden":{const e=getSideOffsets(await detectOverflow(t,{...o,elementContext:"reference"}),n.reference);return{data:{referenceHiddenOffsets:e,referenceHidden:isAnySideFullyClipped(e)}}}case"escaped":{const e=getSideOffsets(await detectOverflow(t,{...o,altBoundary:!0}),n.floating);return{data:{escapedOffsets:e,escaped:isAnySideFullyClipped(e)}}}default:return{}}}}};function getBoundingRect(e){const t=min(...e.map((e=>e.left))),n=min(...e.map((e=>e.top)));return{x:t,y:n,width:max(...e.map((e=>e.right)))-t,height:max(...e.map((e=>e.bottom)))-n}}function getRectsByLine(e){const t=e.slice().sort(((e,t)=>e.y-t.y)),n=[];let i=null;for(let e=0;e<t.length;e++){const o=t[e];!i||o.y-i.y>i.height/2?n.push([o]):n[n.length-1].push(o),i=o}return n.map((e=>rectToClientRect(getBoundingRect(e))))}const inline=function(e){return void 0===e&&(e={}),{name:"inline",options:e,async fn(t){const{placement:n,elements:i,rects:o,platform:r,strategy:a}=t,{padding:l=2,x:s,y:c}=evaluate(e,t),f=Array.from(await(null==r.getClientRects?void 0:r.getClientRects(i.reference))||[]),m=getRectsByLine(f),g=rectToClientRect(getBoundingRect(f)),d=getSideObjectFromPadding(l);const u=await r.getElementRects({reference:{getBoundingClientRect:function(){if(2===m.length&&m[0].left>m[1].right&&null!=s&&null!=c)return m.find((e=>s>e.left-d.left&&s<e.right+d.right&&c>e.top-d.top&&c<e.bottom+d.bottom))||g;if(m.length>=2){if("x"===getMainAxisFromPlacement(n)){const e=m[0],t=m[m.length-1],i="top"===getSide(n),o=e.top,r=t.bottom,a=i?e.left:t.left,l=i?e.right:t.right;return{top:o,bottom:r,left:a,right:l,width:l-a,height:r-o,x:a,y:o}}const e="left"===getSide(n),t=max(...m.map((e=>e.right))),i=min(...m.map((e=>e.left))),o=m.filter((n=>e?n.left===i:n.right===t)),r=o[0].top,a=o[o.length-1].bottom;return{top:r,bottom:a,left:i,right:t,width:t-i,height:a-r,x:i,y:r}}return g}},floating:i.floating,strategy:a});return o.reference.x!==u.reference.x||o.reference.y!==u.reference.y||o.reference.width!==u.reference.width||o.reference.height!==u.reference.height?{reset:{rects:u}}:{}}}};async function convertValueToCoords(e,t){const{placement:n,platform:i,elements:o}=e,r=await(null==i.isRTL?void 0:i.isRTL(o.floating)),a=getSide(n),l=getAlignment(n),s="x"===getMainAxisFromPlacement(n),c=["left","top"].includes(a)?-1:1,f=r&&s?-1:1,m=evaluate(t,e);let{mainAxis:g,crossAxis:d,alignmentAxis:u}="number"==typeof m?{mainAxis:m,crossAxis:0,alignmentAxis:null}:{mainAxis:0,crossAxis:0,alignmentAxis:null,...m};return l&&"number"==typeof u&&(d="end"===l?-1*u:u),s?{x:d*f,y:g*c}:{x:g*c,y:d*f}}const offset=function(e){return void 0===e&&(e=0),{name:"offset",options:e,async fn(t){const{x:n,y:i}=t,o=await convertValueToCoords(t,e);return{x:n+o.x,y:i+o.y,data:o}}}};function getCrossAxis(e){return"x"===e?"y":"x"}const shift=function(e){return void 0===e&&(e={}),{name:"shift",options:e,async fn(t){const{x:n,y:i,placement:o}=t,{mainAxis:r=!0,crossAxis:a=!1,limiter:l={fn:e=>{let{x:t,y:n}=e;return{x:t,y:n}}},...s}=evaluate(e,t),c={x:n,y:i},f=await detectOverflow(t,s),m=getMainAxisFromPlacement(getSide(o)),g=getCrossAxis(m);let d=c[m],u=c[g];if(r){const e="y"===m?"bottom":"right";d=within(d+f["y"===m?"top":"left"],d,d-f[e])}if(a){const e="y"===g?"bottom":"right";u=within(u+f["y"===g?"top":"left"],u,u-f[e])}const p=l.fn({...t,[m]:d,[g]:u});return{...p,data:{x:p.x-n,y:p.y-i}}}}},limitShift=function(e){return void 0===e&&(e={}),{options:e,fn(t){const{x:n,y:i,placement:o,rects:r,middlewareData:a}=t,{offset:l=0,mainAxis:s=!0,crossAxis:c=!0}=evaluate(e,t),f={x:n,y:i},m=getMainAxisFromPlacement(o),g=getCrossAxis(m);let d=f[m],u=f[g];const p=evaluate(l,t),h="number"==typeof p?{mainAxis:p,crossAxis:0}:{mainAxis:0,crossAxis:0,...p};if(s){const e="y"===m?"height":"width",t=r.reference[m]-r.floating[e]+h.mainAxis,n=r.reference[m]+r.reference[e]-h.mainAxis;d<t?d=t:d>n&&(d=n)}if(c){var x,y;const e="y"===m?"width":"height",t=["top","left"].includes(getSide(o)),n=r.reference[g]-r.floating[e]+(t&&(null==(x=a.offset)?void 0:x[g])||0)+(t?0:h.crossAxis),i=r.reference[g]+r.reference[e]+(t?0:(null==(y=a.offset)?void 0:y[g])||0)-(t?h.crossAxis:0);u<n?u=n:u>i&&(u=i)}return{[m]:d,[g]:u}}}},size=function(e){return void 0===e&&(e={}),{name:"size",options:e,async fn(t){const{placement:n,rects:i,platform:o,elements:r}=t,{apply:a=(()=>{}),...l}=evaluate(e,t),s=await detectOverflow(t,l),c=getSide(n),f=getAlignment(n),m="x"===getMainAxisFromPlacement(n),{width:g,height:d}=i.floating;let u,p;"top"===c||"bottom"===c?(u=c,p=f===(await(null==o.isRTL?void 0:o.isRTL(r.floating))?"start":"end")?"left":"right"):(p=c,u="end"===f?"top":"bottom");const h=d-s[u],x=g-s[p],y=!t.middlewareData.shift;let w=h,v=x;if(m){const e=g-s.left-s.right;v=f||y?min(x,e):e}else{const e=d-s.top-s.bottom;w=f||y?min(h,e):e}if(y&&!f){const e=max(s.left,0),t=max(s.right,0),n=max(s.top,0),i=max(s.bottom,0);m?v=g-2*(0!==e||0!==t?e+t:max(s.left,s.right)):w=d-2*(0!==n||0!==i?n+i:max(s.top,s.bottom))}await a({...t,availableWidth:v,availableHeight:w});const A=await o.getDimensions(r.floating);return g!==A.width||d!==A.height?{reset:{rects:!0}}:{}}}};export{arrow,autoPlacement,computePosition,detectOverflow,flip,hide,inline,limitShift,offset,rectToClientRect,shift,size};
//# sourceMappingURL=/sm/71d48e32687f0ab3deec2718525dfc99562e558435615a2f401cc9e0bf192074.map