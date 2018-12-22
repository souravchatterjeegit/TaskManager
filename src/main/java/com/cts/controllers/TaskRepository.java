package com.cts.controllers;

import java.util.Date;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.stereotype.Repository;

import com.cts.vo.Task;
import com.cts.vo.TaskRowMapper;

@Repository
public class TaskRepository {
	private DataSource dataSource;
	private JdbcTemplate jdbcTemplate;
	
	@Autowired
	public void setDataSource(DataSource dSource){
		this.dataSource = dSource;
		this.jdbcTemplate = new JdbcTemplate(dSource);
	}
	
	public List<Task> getTasks(){
		String SQL = "select * from task t left join parent_task pt on t.parent_id = pt.parent_id" ;	
		TaskRowMapper taskMapper = new TaskRowMapper();
		List<Task> taskList = (List<Task>)jdbcTemplate.query(SQL, taskMapper);
		return taskList;
	}	
	public void addTask(Task task){
		String SQL = "insert into task(parent_id,task_name,start_date,end_date,priority) values(?,?,?,?,?)";
		jdbcTemplate.update(SQL,task.getParentId(),task.getTask(),task.getStartDate(),task.getEndDate(),task.getPriority());
		String SQL2 = "insert into parent_task(parent_task) values(?)";
		jdbcTemplate.update(SQL2,task.getTask());
	}
	
	public void updateTask(Task task){
		String SQL = "update task set parent_id=?,task_name=?,start_date=?,end_date=?,priority=? where task_id=?";
		jdbcTemplate.update(SQL,task.getParentId(),task.getTask(),task.getStartDate(),task.getEndDate(),task.getPriority(),task.getTaskId());
		String SQL2 = "update parent_task set parent_task=? where parent_id=?";
		jdbcTemplate.update(SQL2,task.getTask(),task.getTaskId());
	}
	
	public void endTask(Task task){
		Date date = new Date();
		String SQL = "update task set task_ended=true,end_date=? where task_id=?";
		jdbcTemplate.update(SQL,date,task.getTaskId());
	}
}
