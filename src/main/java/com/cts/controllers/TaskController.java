package com.cts.controllers;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.servlet.ModelAndView;

import com.cts.vo.Task;

@Controller
public class TaskController {
	@Autowired
	TaskRepository trepo;
	
	List<Task> tasks = new ArrayList<Task>();
	@RequestMapping(value="/task")
	public ModelAndView getInsurance(ModelAndView model){
		model.setViewName("task");
		return model;
	}
	
	@RequestMapping(method = RequestMethod.GET, path = "/getTasks", produces = "application/json")
	@ResponseBody
	public ResponseEntity<List<Task>> getTasks(ModelAndView model)
			throws Exception {
		tasks = new ArrayList<Task>();
		tasks = trepo.getTasks();
		return new ResponseEntity<List<Task>>(tasks, HttpStatus.OK);
	}
	
	@RequestMapping(method = RequestMethod.POST, path = "/addUpdateTask", consumes = "application/json", produces = "application/json")
	@ResponseStatus(HttpStatus.CREATED)
	@ResponseBody
	public ResponseEntity<List<Task>> addTask(@RequestBody Task task) 
			throws Exception{
		if(task.getTaskId() == 0){
			trepo.addTask(task);
		}else{
			trepo.updateTask(task);
		}
		tasks = trepo.getTasks();
		return new ResponseEntity<List<Task>>(tasks, HttpStatus.OK); 
	}
	
	@RequestMapping(method = RequestMethod.POST, path = "/endTask", consumes = "application/json", produces = "application/json")
	@ResponseBody
	public ResponseEntity<List<Task>> endTask(@RequestBody Task task) 
			throws Exception{	
		trepo.endTask(task);
		tasks = trepo.getTasks();
		return new ResponseEntity<List<Task>>(tasks, HttpStatus.OK); 
	}
}
