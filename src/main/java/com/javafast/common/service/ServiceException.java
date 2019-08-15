package com.javafast.common.service;

/**
 * Service层公用的Exception, 从由Spring管理事务的函数中抛出时会触发事务回滚.
 * @author JavaFast
 */
public class ServiceException extends RuntimeException {
	private String code; // 返回码

	private static final long serialVersionUID = 1L;

	public ServiceException() {
		super();
	}

	public ServiceException(String message) {
		super(message);
	}

	public ServiceException(Throwable cause) {
		super(cause);
	}

	public ServiceException(String code, String message) {
		super(message);
		this.setCode(code);
	}

	public ServiceException(String code,Throwable cause) {
		super(cause);
		this.setCode(code);
	}

	public String getCode() {
		return code;
	}

	public void setCode(String code) {
		this.code = code;
	}

}
