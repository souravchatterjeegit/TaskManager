package com.cts.vo;

import java.util.Date;

public class Task {
	private String task;
	private long taskId;
	private long parentId;
	private Date startDate;
	private Date endDate;
	private int priority;
	private String parent;
	private boolean taskended;
	public String getTask() {
		return task;
	}
	public void setTask(String task) {
		this.task = task;
	}
	public long getTaskId() {
		return taskId;
	}
	public void setTaskId(long taskId) {
		this.taskId = taskId;
	}
	public long getParentId() {
		return parentId;
	}
	public void setParentId(long parentId) {
		this.parentId = parentId;
	}
	public Date getStartDate() {
		return startDate;
	}
	public void setStartDate(Date startDate) {
		this.startDate = startDate;
	}
	public Date getEndDate() {
		return endDate;
	}
	public void setEndDate(Date endDate) {
		this.endDate = endDate;
	}
	public int getPriority() {
		return priority;
	}
	public void setPriority(int priority) {
		this.priority = priority;
	}
	public String getParent() {
		return parent;
	}
	public void setParent(String parent) {
		this.parent = parent;
	}
	public boolean isTaskended() {
		return taskended;
	}
	public void setTaskended(boolean taskended) {
		this.taskended = taskended;
	}
	public Task(String task, long taskId, long parentId, Date startDate,
			Date endDate, int priority, String parent, boolean taskended) {
		super();
		this.task = task;
		this.taskId = taskId;
		this.parentId = parentId;
		this.startDate = startDate;
		this.endDate = endDate;
		this.priority = priority;
		this.parent = parent;
		this.taskended = taskended;
	}
	public Task() {
		super();
	}
	
}
