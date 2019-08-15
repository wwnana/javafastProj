package com.javafast.modules.main.utils;

import java.math.BigDecimal;
import java.util.Date;

import com.javafast.common.config.Global;
import com.javafast.common.utils.SpringContextHolder;
import com.javafast.common.utils.StringUtils;
import com.javafast.modules.crm.dao.CrmChanceDao;
import com.javafast.modules.crm.dao.CrmContacterDao;
import com.javafast.modules.crm.dao.CrmCustomerDao;
import com.javafast.modules.crm.dao.CrmQuoteDao;
import com.javafast.modules.crm.entity.CrmChance;
import com.javafast.modules.crm.entity.CrmCustomer;
import com.javafast.modules.fi.dao.FiFinanceAccountDao;
import com.javafast.modules.fi.entity.FiFinanceAccount;
import com.javafast.modules.om.dao.OmContractDao;
import com.javafast.modules.pay.dao.PayBankbookBalanceDao;
import com.javafast.modules.pay.entity.PayBankbookBalance;
import com.javafast.modules.qws.utils.WorkWechatMsgUtils;
import com.javafast.modules.report.dao.CrmDataOwnDao;
import com.javafast.modules.report.entity.CrmDataOwn;
import com.javafast.modules.sys.entity.SysAccount;
import com.javafast.modules.sys.entity.User;
import com.javafast.modules.wms.dao.WmsWarehouseDao;
import com.javafast.modules.wms.entity.WmsWarehouse;

/**
 * 数据初始化工具
 * @author syh
 *
 */
public class InitDataUtils {

	private static final String requestUrl = Global.getConfig("webSite")+Global.getConfig("adminPath");
	
	private static PayBankbookBalanceDao payBankbookBalanceDao = SpringContextHolder.getBean(PayBankbookBalanceDao.class);
	private static FiFinanceAccountDao fiFinanceAccountDao = SpringContextHolder.getBean(FiFinanceAccountDao.class);
	private static WmsWarehouseDao wmsWarehouseDao = SpringContextHolder.getBean(WmsWarehouseDao.class);
	private static CrmCustomerDao crmCustomerDao = SpringContextHolder.getBean(CrmCustomerDao.class);
	private static CrmContacterDao crmContacterDao = SpringContextHolder.getBean(CrmContacterDao.class);
	private static CrmChanceDao crmChanceDao = SpringContextHolder.getBean(CrmChanceDao.class);
	private static CrmQuoteDao crmQuoteDao = SpringContextHolder.getBean(CrmQuoteDao.class);
	private static CrmDataOwnDao crmDataOwnDao = SpringContextHolder.getBean(CrmDataOwnDao.class);
	
	/**
	 * 初始化企业数据
	 * @param sysAccount
	 * @param createBy
	 */
	public static void initData(SysAccount sysAccount, User createBy){
		
		//创建企业钱包账户
		PayBankbookBalance payBankbookBalance = new PayBankbookBalance();
		payBankbookBalance.setId(sysAccount.getId());
		payBankbookBalance.setBalance(BigDecimal.ZERO);
		payBankbookBalanceDao.insert(payBankbookBalance);
				
		//创建默认仓库
		WmsWarehouse wmsWarehouse = new WmsWarehouse();		
		wmsWarehouse.setNo("01");
		wmsWarehouse.setName("默认仓库");
		wmsWarehouse.setIsDefault("1");
		wmsWarehouse.setStatus("0");
		wmsWarehouse.setCreateBy(createBy);
		wmsWarehouse.setCreateDate(new Date());
		wmsWarehouse.setAccountId(sysAccount.getId());
		wmsWarehouse.preInsert();
		wmsWarehouseDao.insert(wmsWarehouse);
		
		//创建默认结算账户
		FiFinanceAccount fiFinanceAccount = new FiFinanceAccount();		
		fiFinanceAccount.setName("默认账户");
		fiFinanceAccount.setIsDefault("1");
		fiFinanceAccount.setBalance(BigDecimal.ZERO);
		fiFinanceAccount.setStatus("0");
		fiFinanceAccount.setCreateBy(createBy);
		fiFinanceAccount.setCreateDate(new Date());
		fiFinanceAccount.setAccountId(sysAccount.getId());
		fiFinanceAccount.preInsert();
		fiFinanceAccountDao.insert(fiFinanceAccount);
		
		//创建默认供应商分类
		
		
		//创建默认文章分类
		
		
		//创建演示客户数据
		CrmCustomer crmCustomer = new CrmCustomer();
		crmCustomer.setName(sysAccount.getName());
		crmCustomer.setCustomerStatus("0");
		crmCustomer.setCustomerLevel("0");
		crmCustomer.setIsPool("0");
		crmCustomer.setOwnBy(createBy);
		crmCustomer.setCreateBy(createBy);
		crmCustomer.setCreateDate(new Date());
		crmCustomer.setAccountId(sysAccount.getId());
		crmCustomer.preInsert();
		crmCustomerDao.insert(crmCustomer);
		
		//创建演示商机
		CrmChance crmChance = new CrmChance();
		crmChance.setCustomer(crmCustomer);
		crmChance.setName("演示商机-"+sysAccount.getName());
		crmChance.setSaleAmount("50000");
		crmChance.setPeriodType("1");
		crmChance.setProbability(80);
		crmChance.setChangeType("0");
		crmChance.setOwnBy(createBy);
		crmChance.setCreateBy(createBy);
		crmChance.setCreateDate(new Date());
		crmChance.setAccountId(sysAccount.getId());
		crmChance.preInsert();
		crmChanceDao.insert(crmChance);
	}
	
	/**
	 * 数据交接
	 * @param user 移交人
	 * @param ownBy 接收人
	 */
	public static void workOverData(User user, User ownBy){
		
		CrmDataOwn crmDataOwn = new CrmDataOwn();
		crmDataOwn.setUserId(user.getId());
		crmDataOwn.setOwnById(ownBy.getId());
		crmDataOwn.setOfficeId(ownBy.getOffice().getId());
		
		//线索数据交接
		crmDataOwnDao.updateClueDataOwnBy(crmDataOwn);
		
		//客户数据交接
		crmDataOwnDao.updateCustomerDataOwnBy(crmDataOwn);
		
		//联系人数据交接
		crmDataOwnDao.updateContacterDataOwnBy(crmDataOwn);
		
		//商机数据交接
		crmDataOwnDao.updateChanceDataOwnBy(crmDataOwn);
		
		//报价单数据交接
		crmDataOwnDao.updateQuoteDataOwnBy(crmDataOwn);
		
		//合同数据交接
		crmDataOwnDao.updateContractDataOwnBy(crmDataOwn);
		
		//微信消息提醒
		if(StringUtils.isNotBlank(ownBy.getUserId()))
			WorkWechatMsgUtils.sendMsg(ownBy.getUserId(), user.getName()+"将工作(线索、客户、联系人、商机、合同)移交给您，<a href=\""+requestUrl+"\">点击查看</a>", ownBy.getAccountId());
	}
}
