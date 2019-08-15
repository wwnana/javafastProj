<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="org.apache.shiro.web.filter.authc.FormAuthenticationFilter"%>
<%@ include file="/WEB-INF/views/include/taglib.jsp"%>
<!DOCTYPE html>
<html>

	<head>
		<meta name="description" content="User login page" />
		<meta name="viewport" content="width=device-width, initial-scale=1.0" />
		<%@ include file="/WEB-INF/views/include/loginhead.jsp"%>
</head>
<body>
<body class="" style="background: #fff;">
    <div class="wrapper-content">	
    <div class="row">
        	<div class="" style="margin-left:10px;margin-right: 10px;background: #fff;">
        	
        	
        	<div class="ibox-content">
	<h1 class="center">注册协议</h1>
	<div class="form-signin" >
		

		<p>${fns:getConfig('productName')} 标准版（以下简称标准版）是由深圳创之新科技有限公司（以下简称创之新）在该公司${fns:getConfig('productName')}网站上创建的客户管理系统专业化管理平台。若您申请创之新${fns:getConfig('productName')}标准版帐户（以下简称标准版帐户）并使用相应服务，您必须首先同意此协议。 
<p>一、接受 

<p>（1）当您使用服务时，您知晓并且同意此《${fns:getConfig('productName')}标准版帐户协议》； 

<p>（2）此协议在必要时将进行修改更新，网站发布后立即生效； 属于政策性调整的，在30天内将通过电子邮件的方式通知帐户； 

<p>（3）如果您拒绝接受新的协议，将被视为放弃使用${fns:getConfig('productName')}网站标准版提供的服务；若您继续使用该标准版提供的服务，则表明您接受新的协议； 

<p>（4）除非特别声明，某些增强服务的新功能将适用此协议； 

<p>（5）此协议只有创之新该标准版的书面授权人员才可以修改。 

<p>二、服务内容 

<p>（1）此协议所述服务仅在创之新${fns:getConfig('productName')}网站中文网站内有效。创之新中文网站是指http://www.${fns:getConfig('productName')}.com及其所属网页； 

<p>(2) 创之新${fns:getConfig('productName')}标准版为免费版本，无相关附加服务； 

<p>(3) 创之新${fns:getConfig('productName')}标准版有权根据实际情况自主调整服务内容。

<p>三、帐户 

<p>(1)创之新${fns:getConfig('productName')}网站的帐户是能够承担相应法律责任的公司或个人。若您不具备此资格，请不要使用创之新${fns:getConfig('productName')}网站提供的服务；

<p>(2)创之新${fns:getConfig('productName')}网站要求帐户在使用服务时必须遵守相关法律法规。对帐户使用服务所产生的与其他公司或者个人的纠纷不负法律责任；

<p>(3)创之新${fns:getConfig('productName')}网站有权对恶意帐户中止服务，并无需特别通知；

<p>(4)创之新${fns:getConfig('productName')}网站的服务将不提供给那些被临时或永久取消会员资格的公司或个人。 

<p>四、费用 

<p>（1）创之新${fns:getConfig('productName')}网站标准版3个帐户为长期免费，在不超过常规使用、存储、上传数据数量（5M）免费。 

<p>（2）创之新保留对收费模式和具体金额调整的权利，涉及收费服务，将至少提前30天的时间通过电子邮件的形式通知帐户

<p>五、服务期限 

<p>创之新${fns:getConfig('productName')}网站有权判定标准版帐户的行为是否符合《标准版帐户协议》的要求，如果标准版帐户违背了该《标准版帐户协议》的规定，创之新${fns:getConfig('productName')}网站有权决定取消该${fns:getConfig('productName')}标准版帐户资格或者采取其他创之新${fns:getConfig('productName')}网站认为合适的措施。 

<p>六、服务终止 

<p>有下列情形之一的，创之新${fns:getConfig('productName')}网站有权随时暂停、终止、取消或拒绝帐户服务。
<p>（1）帐户违反了此协议或已在约定范围内的任一条款； 

<p>（2）根据此协议相关说明而终止服务； 

<p>（3）利用创之新${fns:getConfig('productName')}网站的发布功能滥发重复信息； 

<p>（4）未经请求或授权向创之新${fns:getConfig('productName')}网站帐户发送大量与业务不相关的信息； 

<p>（5）冒用其他企业的名义发布商业信息，进行商业活动； 

<p>（6）攻击创之新${fns:getConfig('productName')}网站的数据、网络或服务； 

<p>（7）盗用他人在创之新${fns:getConfig('productName')}网站上的帐户名和 / 或密码。 

<p>以下信息是严格禁止并绝对终止帐户服务的： 

<p>（1）有关宗教、种族或性别的贬损言辞； 

<p>（2）骚扰、滥用或威胁其他帐户； 

<p>（3）侵犯任何第三方著作权、专利、商标、商业秘密或其它专有权利、发表权或隐私权的信息； 

<p>（4）其它任何违反互联网相关法律法规的信息。 

<p>七、安全策略 

<p>（1）创之新${fns:getConfig('productName')}网站采取安全策略。如果帐户触发了创之新${fns:getConfig('productName')}网站的安全机制，将被暂时或永久禁止再次访问创之新${fns:getConfig('productName')}网站。同时，其他 帐户 在 创之新${fns:getConfig('productName')}网 上发布的信息将暂时或永久不能被该帐户查看； 

<p>（2）登录名，密码和安全 

<p>在注册过程中，您可自主选择一个登录名和密码，并须对其保密性负责，同时对使用该登录名和密码的所有活动负责。您同意： 

<p>（1）对非授权使用您的登录名及密码以及其他破坏安全性的行为，帐户应立即向创之新${fns:getConfig('productName')}网站告知，创之新公司将采取技术措施阻止恶意破坏； 

<p>（2）确保每次使用创之新${fns:getConfig('productName')}网站后正确地离开该站点。创之新${fns:getConfig('productName')}网站对您因没有遵守此协议而造成的损失不负任何法律责任。 

<p>八、标准版帐户的权利和义务 

<p>（1）标准版帐户服务生效后，帐户就可享受标准版相应服务内容；

<p>（2）标准版帐户在使用创之新${fns:getConfig('productName')}网站提供的相应服务时必须保证遵守当地及中国有关法律法规的规定；不得利用该网站进行任何非法活动；遵守所有与使用该网站有关的协议、规定、程序和惯例； 

<p>（3）标准版帐户如需修改自己的帐户信息资料，必须接受创之新${fns:getConfig('productName')}网站的审核与批准。如果标准版帐户 使用虚假的帐户信息资料，创之新${fns:getConfig('productName')}有权终止其服务； 

<p>（4）帐户对输入数据的准确性、可靠性、合法性、适用性等负责 

<p>（5）对由于帐户在使用创之新${fns:getConfig('productName')}网站服务的过程中，违反本协议或通过提及而纳入本协议的条款和规则或帐户违反任何法律或第三方的权利而产生或引起的每一种类和性质的任何索赔、要求、诉讼、损失和损害（实际、特别及后果性的）而言，无论是已知或未知的，包括合理的律师费，帐户同意就此对创之新、创之新${fns:getConfig('productName')}网、员工、所有者及代理进行补偿并使其免受损害。 

<p>九、创之新${fns:getConfig('productName')}网站的权利和义务 

<p>（1） 为标准版帐户提供创之新${fns:getConfig('productName')}网站承诺的服务； 

<p>（2）创之新${fns:getConfig('productName')}网站服务的所有权和经营权未经书面许可仅属于创之新； 

<p>（3）对于因不可抗力造成的服务中断、链接受阻或其他缺陷（包括但不限于自然灾害、社会事件以及因网站所具有的特殊性质而产生的包括黑客攻击、电信部门技术调整导致的影响、政府管制而造成的暂时性关闭在内的任何影响网络正常运营的因素），创之新${fns:getConfig('productName')}网站不承担任何责任，但将尽力减少因此而给会员造成的损失和影响； 

<p>（4）创之新${fns:getConfig('productName')}网站将尽最大努力来减少错误，但网站上提供的服务和信息仍可能包含错误内容，创之新${fns:getConfig('productName')}网站对帐户因使用创之新${fns:getConfig('productName')}网站而造成的损失不负法律责任。创之新${fns:getConfig('productName')}网站对其服务和信息不作保证，不论什么情况下对帐户因使用创之新${fns:getConfig('productName')}网站而造成的直接、间接、偶尔的、特殊的、惩罚性的损害或其他一切损害不负法律责任，即便事先被告知损害存在的可能性也是如此。若您对创之新${fns:getConfig('productName')}网站提供的部分或所有服务不满，您唯一的补救措施是停止使用这些服务; 

<p>（6）如因创之新${fns:getConfig('productName')}网站原因，造成标准版帐户服务的不正常中断，创之新${fns:getConfig('productName')}网不承担任何责任，创之新${fns:getConfig('productName')}网站也不承担由此致使会员蒙受的其它方面的连带损失； 

<p>（7）创之新${fns:getConfig('productName')}网站有权决定删除标准版帐户张贴的任何违反中国法律、法规、《${fns:getConfig('productName')}标准版帐户协议》内容，或其他创之新${fns:getConfig('productName')}网站认为不可接受的内容。情节严重者，创之新${fns:getConfig('productName')}网站有权取消其帐户资格。 

<p>十、创之新${fns:getConfig('productName')}网站对所收集信息的声明 

<p>（1）如果您希望成为创之新${fns:getConfig('productName')}网站的，您必须注册并提供相应的信息。当您在创之新${fns:getConfig('productName')}网站注册成为 帐户 时，创之新${fns:getConfig('productName')}网站需要收集您的姓名、 Email 等信息。当您浏览创之新${fns:getConfig('productName')}网站时，服务器会自动收集您的 IP 地址，此 IP 地址只被计算机用来向您发送相关的页面 , 帮助您监控非授权登陆。 

<p>（2）创之新${fns:getConfig('productName')}网站的 标准版帐户 可以进行发布商业信息，创之新${fns:getConfig('productName')}网站有权审核发布或删除帐户提交的信息。 所有的帐户对其发布信息的准确性、完整性、即时性、合法性都独立承担所有责任，创之新${fns:getConfig('productName')}网站会尽可能检查帐户提交的信息，但并不能完全保证信息的准确性和合法性，同时也不承担由此引至的任何法律责任。创之新${fns:getConfig('productName')}网站在任何情况下均不就因本网站、本网站的服务或本协议而产生或与之有关的利润损失或任何特别、间接或后果性的损害（无论以何种方式产生，包括疏忽）承担任何责任。 

<p>（3）创之新${fns:getConfig('productName')}网站收集全球供应商及其产品信息、全球采购商的需求信息，构建其数据库系统，拥有对相关信息及网站设计的版权，对数据的准确性不付任何责任。任何未经授权的复制或未经许可的基于创之新${fns:getConfig('productName')}网站的商业行为，创之新${fns:getConfig('productName')}网站将保留追究其法律责任的权利。 

<p>十一、最终解释权 

<p>深圳创之新科技有限公司对${fns:getConfig('productName')}保有任何活动、限制等的最终解释权。 

<p>十二、 版权声明 

<p>创之新${fns:getConfig('productName')}网站的所有内容版权属创之新所有，严禁未经创之新书面许可的任何形式的部分或全部拷贝使用。版权所有翻版必究。 

<p>十三．责任免除 

<p>（1）深圳创之新科技有限公司及其代理商对“服务”及其内容的有效性 、正确性 、质量 、稳定性 、可靠性、及时性、适用性、真实性、实用性、准确性或完整性等均不作任何陈述、承诺或保证； 

<p>（2）帐户理解并接受任何信息资料的传输取决于帐户自己并由其承担系统受损或资料丢失的所有风险和责任； 

<p>（3）创之新${fns:getConfig('productName')}网站对帐户之间的商业进程不作任何明示或暗示的承诺与保证； 

<p>（4）创之新${fns:getConfig('productName')}网 、员工、所有者及代理对帐户使用创之新${fns:getConfig('productName')}网站上公布的信息而造成的损失或伤害以及帐户相信创之新${fns:getConfig('productName')}网站上公布的信息内容而做出的决定或采取的行动不负责任； 

<p>（5）创之新${fns:getConfig('productName')}网 、员工、所有者及代理对帐户使用或无法使用创之新${fns:getConfig('productName')}网站的服务而造成的直接的、间接的、偶尔的、特殊的或其他损害不负法律责任，即便事先被告知损害存在的可能性也是如此。 

<p>十四、争议的解决 

<p>创之新${fns:getConfig('productName')}网站与标准版帐户任何一方未履行协议所规定的责任均视为违约，按《合同法》规定处理；如双方在此协议范围内发生纠纷，应尽量友好协商解决。此协议适用中华人民共和国法律。如与此协议有关的某一特定事项缺乏明确法律规定，则应参照通用的国际商业惯例和行业惯例。
	</div>
</div></div></div></div>
</body>
</html>