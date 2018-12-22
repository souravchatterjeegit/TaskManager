package com.cts.vo;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Date;

import org.springframework.jdbc.core.RowMapper;

public class TaskRowMapper implements RowMapper<Task>{
	public Task mapRow(ResultSet rs,int index) throws SQLException{
		long taskid = rs.getLong("task_id");
		String taskName = rs.getString("task_name");
		long parentId = rs.getLong("parent_id");
		String parentName = rs.getString("parent_task");
		if(parentName == null)
			parentName = "";
		Date startDate = rs.getDate("start_date");
		Date endDate = rs.getDate("end_date");
		int priority = rs.getInt("priority");
		boolean taskEnded = rs.getBoolean("task_ended");
		
		Task task = new Task(taskName, taskid, parentId, startDate, endDate, priority, parentName, taskEnded);
		return task;
	}

}
