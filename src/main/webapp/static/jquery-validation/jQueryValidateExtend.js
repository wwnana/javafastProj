/*******************************************************************************
 * 
 * jQuery Validate扩展验证方法 (linjq)
 ******************************************************************************/
$(function() {
	/***************************************************************************
	 * 
	 * 小例子 // 判断浮点数是否大于等于0小于等于100 jQuery.validator.addMethod("ckFloatIn100",
	 * function(value, element) { value = parseFloat(value); return
	 * this.optional(element) || (value <= 100 && value>=0); },
	 * "请输入一个大于等于0小于等于100的值"); //小数范围校验 jQuery.validator.addMethod( "ckFloat",
	 * function(value, element, param) { value = parseFloat(value); return
	 * this.optional(element) || (value >= param[0] && value <= param[1]); },
	 * $.validator.format("请输入大于等于{0}小于等于{1}的值") );
	 **************************************************************************/

	/*
	 * 小数验证，小数点位数按照max参数的小数点位数进行判断 只能输入数字
	 */
	$.validator.addMethod("isDecimal", function(value, element, params) {

		if (params != undefined && typeof (params) == "string"
				&& params.startsWith("[")) {
			params = eval(params);
		}
		// debugger;
		if (isNaN(params[0])) {
			console.error("参数错误，decimal验证的min只能为数字");
			return false;
		}
		if (isNaN(params[1])) {
			console.error("参数错误，decimal验证的max只能为数字");
			return false;
		}
		if (isNaN(params[2])) {
			console.error("参数错误，decimal验证的accuracy只能为数字");
			return false;
		}
		if (isNaN(value)) {
			return false;
		}
		// if(typeof(value) == undefined || value == "") {
		// return false;
		// }
		var min = Number(params[0]);
		var max = Number(params[1]);
		var testVal = Number(value);
		var testAbsVal = Math.abs(testVal);
		if (typeof (params[2]) == undefined || params[2] == 0) {
			var regX = /^\d+$/;
		} else {
			var regxStr = "^\\d+(\\.\\d{1," + params[2] + "})?$";
			var regX = new RegExp(regxStr);
		}
		// console.debug("regX: %o, value: %o, test: %o", regX, value,
		// regX.test(value));
		return this.optional(element)
				|| (regX.test(testAbsVal) && testVal >= min && testVal <= max);
	}, $.validator.format("请输入在{0}到{1}之间且保留小数点后{2}位的值"));

	/* 整数验证,只能输入数字 */
	$.validator.addMethod("isInt", function(value, element, params) {

		if (params != undefined && typeof (params) == "string"
				&& params.startsWith("[")) {
			params = eval(params);
		}
		// debugger;
		if (isNaN(params[0])) {
			console.error("参数错误，decimal验证的min只能为数字");
			return false;
		}
		if (isNaN(params[1])) {
			console.error("参数错误，decimal验证的max只能为数字");
			return false;
		}
		if (isNaN(value)) {
			return false;
		}
		var min = Number(params[0]);
		var max = Number(params[1]);
		var testVal = Number(value);
		var testAbsVal = Math.abs(testVal);
		// console.debug("regX: %o, value: %o, test: %o", regX, value,
		// regX.test(value));
		return this.optional(element) || (testVal >= min && testVal <= max);
	}, $.validator.format("请输入在{0}到{1}之间的整数"));

	/* 只允许输入字母 */
	$.validator.addMethod("isAlphabet", function(value, element) {
		return this.optional(element) || /^[a-zA-Z]+$/.test(value);
	}, $.validator.format("请输入字母"));

	/* 只允许输入字母或数字 */
	$.validator.addMethod("isAlphabetDigits", function(value, element) {
		return this.optional(element) || /^[a-zA-Z0-9]+$/.test(value);
	}, $.validator.format("请输入字母或数字"));

	/* 条码验证 */
	jQuery.validator.addMethod("isBarcode",
			function(value, element) {
				var result = false;
				var length = value.length;
				var d = /^\d{13}$/.test(value);
				if (length == 13 && d) {
					var c1 = parseInt(value.charAt(0))
							+ parseInt(value.charAt(2))
							+ parseInt(value.charAt(4))
							+ parseInt(value.charAt(6))
							+ parseInt(value.charAt(8))
							+ parseInt(value.charAt(10));
					var c2 = (parseInt(value.charAt(1))
							+ parseInt(value.charAt(3))
							+ parseInt(value.charAt(5))
							+ parseInt(value.charAt(7))
							+ parseInt(value.charAt(9)) + parseInt(value
							.charAt(11))) * 3;
					var c3 = parseInt(value.charAt(12))
					var cc = 10 - (c1 + c2) % 10;
					if (cc == 10) {
						cc = 0;
					}
					if (cc == c3) {
						result = true;
					}
				}
				return this.optional(element) || result;
			}, "无效条码");

	/* 字节长度校验 */
	$.validator.addMethod("maxByte", function(value, element, params) {

		var byteLen = 0, len = value.length;
		if (value) {
			for (var i = 0; i < len; i++) {
				if (value.charCodeAt(i) > 255) {
					byteLen += 2;
				} else {
					byteLen++;
				}

			}
		}
		// console.debug(byteLen + " - " + len + " - " + params);
		return this.optional(element) || byteLen <= params;
	}, $.validator.format("字符串长度过长"));
	
	
	
	/* required 提示的修改   使用方法  在form 提交时 rules:{字段name:{requiredTip:"要提示的信息"}}*/
	jQuery.validator.addMethod("requiredTip",
		function(value, element, params) {
//			console.info(params);
			var a = params;
			var len = value.length;
			return  len > 0;
		}, $.validator.format("{0}"));

	
	
	// 手机号码验证
	jQuery.validator.addMethod("isMobile", function(value, element) {
		var length = value.length;
		var mobile = /^(13[0-9]{9})|(18[0-9]{9})|(14[0-9]{9})|(17[0-9]{9})|(15[0-9]{9})$/;
		return this.optional(element) || (length == 11 && mobile.test(value));
	}, "请正确填写您的手机号码");
	
	// 电话号码验证 
	jQuery.validator.addMethod("isTel", function(value, element) { 
	  var tel = /^\d{3,4}-?\d{7,9}$/; //电话号码格式010-12345678 
	  return this.optional(element) || (tel.test(value)); 
	}, "请正确填写您的电话号码"); 
	

	
});
