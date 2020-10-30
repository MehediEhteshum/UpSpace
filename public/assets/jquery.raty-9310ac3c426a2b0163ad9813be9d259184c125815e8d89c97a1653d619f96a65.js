!function(r){"use strict";var l={init:function(t){return this.each(function(){this.self=r(this),l.destroy.call(this.self),this.opt=r.extend(!0,{},r.fn.raty.defaults,t,this.self.data()),l._adjustCallback.call(this),l._adjustNumber.call(this),l._adjustHints.call(this),this.opt.score=l._adjustedScore.call(this,this.opt.score),"img"!==this.opt.starType&&l._adjustStarType.call(this),l._adjustPath.call(this),l._createStars.call(this),this.opt.cancel&&l._createCancel.call(this),this.opt.precision&&l._adjustPrecision.call(this),l._createScore.call(this),l._apply.call(this,this.opt.score),l._setTitle.call(this,this.opt.score),l._target.call(this,this.opt.score),this.opt.readOnly?l._lock.call(this):(this.style.cursor="pointer",l._binds.call(this))})},_adjustCallback:function(){for(var t=["number","readOnly","score","scoreName","target","path"],e=0;e<t.length;e++)"function"==typeof this.opt[t[e]]&&(this.opt[t[e]]=this.opt[t[e]].call(this))},_adjustedScore:function(t){return t?l._between(t,0,this.opt.number):t},_adjustHints:function(){if(this.opt.hints||(this.opt.hints=[]),this.opt.halfShow||this.opt.half)for(var t=this.opt.precision?10:2,e=0;e<this.opt.number;e++){var a=this.opt.hints[e];"[object Array]"!==Object.prototype.toString.call(a)&&(a=[a]),this.opt.hints[e]=[];for(var s=0;s<t;s++){var i=a[s],n=a[a.length-1];n===undefined&&(n=null),this.opt.hints[e][s]=i===undefined?n:i}}},_adjustNumber:function(){this.opt.number=l._between(this.opt.number,1,this.opt.numberMax)},_adjustPath:function(){this.opt.path=this.opt.path||"",this.opt.path&&"/"!==this.opt.path.charAt(this.opt.path.length-1)&&(this.opt.path+="/")},_adjustPrecision:function(){this.opt.half=!0},_adjustStarType:function(){var t=["cancelOff","cancelOn","starHalf","starOff","starOn"];this.opt.path="";for(var e=0;e<t.length;e++)this.opt[t[e]]=this.opt[t[e]].replace(".","-")},_apply:function(t){l._fill.call(this,t),t&&(0<t&&this.score.val(t),l._roundStars.call(this,t))},_between:function(t,e,a){return Math.min(Math.max(parseFloat(t),e),a)},_binds:function(){this.cancel&&(l._bindOverCancel.call(this),l._bindClickCancel.call(this),l._bindOutCancel.call(this)),l._bindOver.call(this),l._bindClick.call(this),l._bindOut.call(this)},_bindClick:function(){var s=this;s.stars.on("click.raty",function(t){var e=!0,a=s.opt.half||s.opt.precision?s.self.data("score"):this.alt||r(this).data("alt");s.opt.click&&(e=s.opt.click.call(s,+a,t)),(e||e===undefined)&&(s.opt.half&&!s.opt.precision&&(a=l._roundHalfScore.call(s,a)),l._apply.call(s,a))})},_bindClickCancel:function(){var e=this;e.cancel.on("click.raty",function(t){e.score.removeAttr("value"),e.opt.click&&e.opt.click.call(e,null,t)})},_bindOut:function(){var a=this;a.self.on("mouseleave.raty",function(t){var e=+a.score.val()||undefined;l._apply.call(a,e),l._target.call(a,e,t),l._resetTitle.call(a),a.opt.mouseout&&a.opt.mouseout.call(a,e,t)})},_bindOutCancel:function(){var s=this;s.cancel.on("mouseleave.raty",function(t){var e=s.opt.cancelOff;if("img"!==s.opt.starType&&(e=s.opt.cancelClass+" "+e),l._setIcon.call(s,this,e),s.opt.mouseout){var a=+s.score.val()||undefined;s.opt.mouseout.call(s,a,t)}})},_bindOver:function(){var a=this,t=a.opt.half?"mousemove.raty":"mouseover.raty";a.stars.on(t,function(t){var e=l._getScoreByPosition.call(a,t,this);l._fill.call(a,e),a.opt.half&&(l._roundStars.call(a,e,t),l._setTitle.call(a,e,t),a.self.data("score",e)),l._target.call(a,e,t),a.opt.mouseover&&a.opt.mouseover.call(a,e,t)})},_bindOverCancel:function(){var s=this;s.cancel.on("mouseover.raty",function(t){var e=s.opt.path+s.opt.starOff,a=s.opt.cancelOn;"img"===s.opt.starType?s.stars.attr("src",e):(a=s.opt.cancelClass+" "+a,s.stars.attr("class",e)),l._setIcon.call(s,this,a),l._target.call(s,null,t),s.opt.mouseover&&s.opt.mouseover.call(s,null)})},_buildScoreField:function(){return r("<input />",{name:this.opt.scoreName,type:"hidden"}).appendTo(this)},_createCancel:function(){var t=this.opt.path+this.opt.cancelOff,e=r("<"+this.opt.starType+" />",{title:this.opt.cancelHint,"class":this.opt.cancelClass});"img"===this.opt.starType?e.attr({src:t,alt:"x"}):e.attr("data-alt","x").addClass(t),"left"===this.opt.cancelPlace?this.self.prepend("&#160;").prepend(e):this.self.append("&#160;").append(e),this.cancel=e},_createScore:function(){var t=r(this.opt.targetScore);this.score=t.length?t:l._buildScoreField.call(this)},_createStars:function(){for(var t=1;t<=this.opt.number;t++){var e=l._nameForIndex.call(this,t),a={alt:t,src:this.opt.path+this.opt[e]};"img"!==this.opt.starType&&(a={"data-alt":t,"class":a.src}),a.title=l._getHint.call(this,t),r("<"+this.opt.starType+" />",a).appendTo(this),this.opt.space&&this.self.append(t<this.opt.number?"&#160;":"")}this.stars=this.self.children(this.opt.starType)},_error:function(t){r(this).text(t),r.error(t)},_fill:function(t){for(var e=0,a=1;a<=this.stars.length;a++){var s,i=this.stars[a-1],n=l._turnOn.call(this,a,t);if(this.opt.iconRange&&this.opt.iconRange.length>e){var o=this.opt.iconRange[e];s=l._getRangeIcon.call(this,o,n),a<=o.range&&l._setIcon.call(this,i,s),a===o.range&&e++}else s=this.opt[n?"starOn":"starOff"],l._setIcon.call(this,i,s)}},_getFirstDecimal:function(t){var e=t.toString().split(".")[1],a=0;return e&&(a=parseInt(e.charAt(0),10),"9999"===e.slice(1,5)&&a++),a},_getRangeIcon:function(t,e){return e?t.on||this.opt.starOn:t.off||this.opt.starOff},_getScoreByPosition:function(t,e){var a=parseInt(e.alt||e.getAttribute("data-alt"),10);if(this.opt.half){var s=l._getWidth.call(this);a=a-1+parseFloat((t.pageX-r(e).offset().left)/s)}return a},_getHint:function(t,e){if(0!==t&&!t)return this.opt.noRatedMsg;var a=l._getFirstDecimal.call(this,t),s=Math.ceil(t),i=this.opt.hints[(s||1)-1],n=i,o=!e||this.move;return this.opt.precision?(o&&(a=0===a?9:a-1),n=i[a]):(this.opt.halfShow||this.opt.half)&&(n=i[a=o&&0===a?1:5<a?1:0]),""===n?"":n||t},_getWidth:function(){var t=this.stars[0].width||parseFloat(this.stars.eq(0).css("font-size"));return t||l._error.call(this,"Could not get the icon width!"),t},_lock:function(){var t=l._getHint.call(this,this.score.val());this.style.cursor="",this.title=t,this.score.prop("readonly",!0),this.stars.prop("title",t),this.cancel&&this.cancel.hide(),this.self.data("readonly",!0)},_nameForIndex:function(t){return this.opt.score&&this.opt.score>=t?"starOn":"starOff"},_resetTitle:function(){for(var t=0;t<this.opt.number;t++)this.stars[t].title=l._getHint.call(this,t+1)},_roundHalfScore:function(t){var e=parseInt(t,10),a=l._getFirstDecimal.call(this,t);return 0!==a&&(a=5<a?1:.5),e+a},_roundStars:function(t,e){var a,s=(t%1).toFixed(2);if(e||this.move?a=.5<s?"starOn":"starHalf":s>this.opt.round.down&&(a="starOn",this.opt.halfShow&&s<this.opt.round.up?a="starHalf":s<this.opt.round.full&&(a="starOff")),a){var i=this.opt[a],n=this.stars[Math.ceil(t)-1];l._setIcon.call(this,n,i)}},_setIcon:function(t,e){t["img"===this.opt.starType?"src":"className"]=this.opt.path+e},_setTarget:function(t,e){e&&(e=this.opt.targetFormat.toString().replace("{score}",e)),t.is(":input")?t.val(e):t.html(e)},_setTitle:function(t,e){if(t){var a=parseInt(Math.ceil(t),10);this.stars[a-1].title=l._getHint.call(this,t,e)}},_target:function(t,e){if(this.opt.target){var a=r(this.opt.target);a.length||l._error.call(this,"Target selector invalid or missing!");var s=e&&"mouseover"===e.type;if(t===undefined)t=this.opt.targetText;else if(null===t)t=s?this.opt.cancelHint:this.opt.targetText;else{"hint"===this.opt.targetType?t=l._getHint.call(this,t,e):this.opt.precision&&(t=parseFloat(t).toFixed(1));var i=e&&"mousemove"===e.type;s||i||this.opt.targetKeep||(t=this.opt.targetText)}l._setTarget.call(this,a,t)}},_turnOn:function(t,e){return this.opt.single?t===e:t<=e},_unlock:function(){this.style.cursor="pointer",this.removeAttribute("title"),this.score.removeAttr("readonly"),this.self.data("readonly",!1);for(var t=0;t<this.opt.number;t++)this.stars[t].title=l._getHint.call(this,t+1);this.cancel&&this.cancel.css("display","")},cancel:function(e){return this.each(function(){var t=r(this);!0!==t.data("readonly")&&(l[e?"click":"score"].call(t,null),this.score.removeAttr("value"))})},click:function(t){return this.each(function(){!0!==r(this).data("readonly")&&(t=l._adjustedScore.call(this,t),l._apply.call(this,t),this.opt.click&&this.opt.click.call(this,t,r.Event("click")),l._target.call(this,t))})},destroy:function(){return this.each(function(){var t=r(this),e=t.data("raw");e?t.off(".raty").empty().css({cursor:e.style.cursor}).removeData("readonly"):t.data("raw",t.clone()[0])})},getScore:function(){var t,e=[];return this.each(function(){t=this.score.val(),e.push(t?+t:undefined)}),1<e.length?e:e[0]},move:function(o){return this.each(function(){var t=parseInt(o,10),e=l._getFirstDecimal.call(this,o);t>=this.opt.number&&(t=this.opt.number-1,e=10);var a=l._getWidth.call(this)/10,s=r(this.stars[t]),i=s.offset().left+a*e,n=r.Event("mousemove",{pageX:i});this.move=!0,s.trigger(n),this.move=!1})},readOnly:function(e){return this.each(function(){var t=r(this);t.data("readonly")!==e&&(e?(t.off(".raty").children(this.opt.starType).off(".raty"),l._lock.call(this)):(l._binds.call(this),l._unlock.call(this)),t.data("readonly",e))})},reload:function(){return l.set.call(this,{})},score:function(){var t=r(this);return arguments.length?l.setScore.apply(t,arguments):l.getScore.call(t)},set:function(t){return this.each(function(){r(this).raty(r.extend({},this.opt,t))})},setScore:function(t){return this.each(function(){!0!==r(this).data("readonly")&&(t=l._adjustedScore.call(this,t),l._apply.call(this,t),l._target.call(this,t))})}};r.fn.raty=function(t){return l[t]?l[t].apply(this,Array.prototype.slice.call(arguments,1)):"object"!=typeof t&&t?void r.error("Method "+t+" does not exist!"):l.init.apply(this,arguments)},r.fn.raty.defaults={cancel:!1,cancelClass:"raty-cancel",cancelHint:"Cancel this rating!",cancelOff:"cancel-off.png",cancelOn:"cancel-on.png",cancelPlace:"left",click:undefined,half:!1,halfShow:!0,hints:["bad","poor","satisfactory","good","amazing"],iconRange:undefined,mouseout:undefined,mouseover:undefined,noRatedMsg:"Not rated yet!",number:5,numberMax:20,path:"/",precision:!1,readOnly:!1,round:{down:.25,full:.6,up:.76},score:undefined,scoreName:"score",single:!1,space:!0,starHalf:"star-half.png",starOff:"star-off.png",starOn:"star-on.png",starType:"img",target:undefined,targetFormat:"{score}",targetKeep:!1,targetScore:undefined,targetText:"",targetType:"hint"}}(jQuery);