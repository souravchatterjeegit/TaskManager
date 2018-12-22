<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
   "http://www.w3.org/TR/html4/loose.dtd">
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<html>

<head>
    <script src = "https://ajax.googleapis.com/ajax/libs/angularjs/1.6.9/angular.min.js"></script>
    <script>
        var taskArray = [{ "task": "parent task", "taskId":1, "priority":2, "startDate": "2018-08-01", "endDate":"2018-12-31", "parent":"", "taskended":false },
            { "task": "parent task1", "taskId":1, "priority":20, "startDate": "2018-08-01", "endDate":"2018-12-31", "parent":"parent task", "taskended":false }];
        function formatDateForOutput(date) {
            var d = new Date(date),
            month = '' + (d.getMonth() + 1),
            day = '' + d.getDate(),
            year = d.getFullYear();

            if (month.length < 2) month = '0' + month;
            if (day.length < 2) day = '0' + day;

            return [year, month, day].join('-');
        }
        var taskApp = angular.module("taskApp",[]);
        taskApp.directive("formatDate", function(){
            return {
                require: 'ngModel',
                link: function(scope, elem, attr, modelCtrl) {
                    modelCtrl.$formatters.push(function(modelValue){
                        return new Date(modelValue);
                    })
                }
            }
        });
        taskApp.filter("dateformatter",function(){
        	return function(date){
        		var d = new Date(date),
            	month = '' + (d.getMonth() + 1),
            	day = '' + d.getDate(),
            	year = d.getFullYear();

            	if (month.length < 2) month = '0' + month;
            	if (day.length < 2) day = '0' + day;

            	return [year, month, day].join('-');
        	}
        });
        taskApp.controller("taskController",function($scope,$http){
            $scope.showViewPage = false;
            $scope.showAddEditPage = true;
            $scope.updateAddTest = "Add Task";
            $scope.idToBeUpdated = 0;
            $scope.alertmessage = "";
            $scope.priority = 0;
            //$scope.tasks = taskArray;
            $scope.taskName = "";
            $scope.parentTask = 0;
            $scope.startDate="2018-01-01";
            $scope.endDate="2018-12-31";
            $scope.populateList = function(){
            	$http.get("/TaskManager/getTasks")
  					.then(function(response) {
      				$scope.tasks = response.data;            
  				});
            }
            $scope.populateList();
            $scope.viewAddEdit = function(){ 
                $scope.showViewPage = false;
                $scope.showAddEditPage = true;
                $scope.resetForm();
            }
            $scope.viewList = function(){ 
                $scope.showViewPage = true;
                $scope.showAddEditPage = false;
            }
            $scope.taskFilter = function(item){
                var nameSearch = false; 
                var parentSearch = false;
                var prioritySearch = false;
                var dateSearch = false;
                if(!$scope.searchName)
                    nameSearch = true;
                else if(item.task.indexOf($scope.searchName) != -1)
                    nameSearch = true;
                
                if(!$scope.searchParentName)
                    parentSearch = true;
                else if(item.parent.indexOf($scope.searchParentName) != -1)
                    parentSearch = true;
                
                if(!$scope.searchPriorityMin && !$scope.searchPriorityMax)
                    prioritySearch = true;
                else if(!$scope.searchPriorityMin && $scope.searchPriorityMax && item.priority<=$scope.searchPriorityMax)
                    prioritySearch = true;
                else if(!$scope.searchPriorityMax && $scope.searchPriorityMin && item.priority>=$scope.searchPriorityMin)
                    prioritySearch = true;
                else if($scope.searchPriorityMin && $scope.searchPriorityMax && item.priority<=$scope.searchPriorityMax
                        && item.priority>=$scope.searchPriorityMin)
                    prioritySearch = true;

                if(!$scope.searchStartDate && !$scope.searchEndDate) 
                    dateSearch = true;
                else if($scope.searchStartDate && !$scope.searchEndDate){
                    if(new Date($scope.searchStartDate).toDateString() == new Date(item.startDate).toDateString())
                        dateSearch = true;
                }    
                else if($scope.searchEndDate && !$scope.searchStartDate){
                    if(new Date($scope.searchEndDate).toDateString() == new Date(item.endDate).toDateString())
                        dateSearch = true;
                }else if($scope.searchEndDate && $scope.searchStartDate){
                    if((new Date($scope.searchStartDate).toDateString() == new Date(item.startDate).toDateString())&&
                    (new Date($scope.searchEndDate).toDateString() == new Date(item.endDate).toDateString()))
                        dateSearch = true;
                }
                
                
                return nameSearch&&parentSearch&&prioritySearch&&dateSearch;
            }
            $scope.taskSubmitted = function(){
                $scope.alertmessage = "";
                var startDate = new Date($scope.startDate);
                var endDate = new Date($scope.endDate);
                if((startDate - endDate) > 0){
                    $scope.alertmessage = "Startdate cannot succeed enddate, task not added";
                }
                else if($scope.updateAddTest == "Add Task"){ 
                	var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/TaskManager/addUpdateTask',
                		dataType: "json",//optional
                		data: { "task": $scope.taskName, "priority": $scope.priority, "startDate": $scope.startDate, "endDate": $scope.endDate, "parentId": $scope.parentTask, "taskended": false }
                	}
                	$http(req).then(function(response){
                		$scope.alertmessage = "task " + $scope.taskName + " is successfully added ";
                    	$scope.priority = 0;
                    	$scope.taskName = "";
                    	$scope.parentTask = 0;
                    	$scope.startDate="2018-01-01";
                    	$scope.endDate="2018-12-31";
                    	$scope.updateAddTest = "Add Task";
                    	$scope.tasks = response.data;
                	}, function(){
                		$scope.alertmessage = "task creation error ";
                	});
                    //$scope.tasks.push({ "task": $scope.taskName, "priority":$scope.priority, "startDate": formatDateForOutput($scope.startDate), "endDate": formatDateForOutput($scope.endDate), "parent":$scope.parentTask, "taskended":false });
                }else if($scope.updateAddTest == "Update Task"){
                	var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/TaskManager/addUpdateTask',
                		dataType: "json",//optional
                		data: { "task": $scope.taskName, "taskId": $scope.idToBeUpdated ,"priority": $scope.priority, "startDate": $scope.startDate, "endDate": $scope.endDate, "parentId": $scope.parentTask, "taskended": false }
                	}
                	$http(req).then(function(response){
                		$scope.alertmessage = "task " + $scope.taskName + " is successfully updated ";
                    	$scope.priority = 0;
                    	$scope.taskName = "";
                    	$scope.parentTask = 0;
                    	$scope.startDate="2018-01-01";
                    	$scope.endDate="2018-12-31";
                    	$scope.updateAddTest = "Add Task";
                    	$scope.tasks = response.data;
                	}, function(){
                		$scope.alertmessage = "task updation error ";
                	});
                    
                }
            }
            $scope.resetForm = function(){
                $scope.alertmessage = "";
                $scope.priority = 0;
                //$scope.tasks = taskArray;
                $scope.taskName = "";
                $scope.parentTask = 0;
                $scope.startDate="2018-01-01";
                $scope.endDate="2018-12-31";
                $scope.updateAddTest = "Add Task";
            }
            $scope.updateTask = function(index){  //alert($scope.parentTask);
            		for(var i=0;i<$scope.tasks.length;i++){
            			if($scope.tasks[i].taskId == index){
            				var parentId = $scope.tasks[i].parentId;
            				if(parentId == null)
            					parentId = 0;
            				$scope.parentTask = parentId.toString();
            				//alert(" $scope.parentTask 2 " + $scope.parentTask + " $scope.tasks[i].parentId " + $scope.tasks[i].parentId);
                    		$scope.showViewPage = false;
                    		$scope.showAddEditPage = true;
                    		$scope.alertmessage = "";
                    		$scope.priority = $scope.tasks[i].priority;
                    		$scope.taskName = $scope.tasks[i].task;
                    		$scope.startDate = $scope.tasks[i].startDate;
                    		$scope.endDate = $scope.tasks[i].endDate;
                    		$scope.idToBeUpdated = index;
                    		$scope.updateAddTest = "Update Task";
                    		break;
            			}
            		}
                    //alert($scope.tasks[index].parentId + " updated one " + $scope.parentTask);
            }
            $scope.endTask = function(index){
                var req={
                		contentType: "application/json; charset=utf-8",//required
                		method: 'POST',
                		url: '/TaskManager/endTask',
                		dataType: "json",
                		data: { "taskId": index }
                	}
                	$http(req).then(function(response){
                		$scope.tasks = response.data;
                	}, function(){
                		$scope.alertmessage = "task updation error ";
                	});
            }
            
        })
    </script>
    <style>
        .slider {
            -webkit-appearance: none;
            width: 95.5%;
            height: 15px;
            border-radius: 5px;   
            background: #d3d3d3;
            outline: none;
            opacity: 0.7;
            -webkit-transition: .2s;
            transition: opacity .2s;
        }

        .slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 25px;
            height: 25px;
            border-radius: 50%; 
            background: #4CAF50;
            cursor: pointer;
        }

        .slider::-moz-range-thumb {
            width: 25px;
            height: 25px;
            border-radius: 50%;
            background: #4CAF50;
            cursor: pointer;
        }
    </style>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css" integrity="sha384-MCw98/SFnGE8fJT3GXwEOngsV7Zt27NXFoaoApmYm81iuXoPkFOJwJ8ERdknLPMO"
        crossorigin="anonymous">
</head>

<body ng-app="taskApp" ng-controller="taskController">
    <div class="row form-group"></div>
    <div class="row justify-content-center form-group">
        <div id="navDiv" class="col-md-8 col-sm-8 col-xs-8 col-xs-offset-2 col-md-offset-2 col-sm-offset-2 bg-white border rounded">
            <button class="btn btn-link" ng-click="viewAddEdit()">Add/Update Task</button>
            <button class="btn btn-link" ng-click="viewList()">View Task</button>
        </div>
    </div>
    <div class="row justify-content-center form-group">
        <!-- This is for add/edit tasks page -->
        <div class="col-md-8 col-sm-8 col-xs-8 col-xs-offset-2 col-md-offset-2 col-sm-offset-2 bg-white border rounded" ng-show="showAddEditPage">
            <form name="taskForm" novalidate>
                <div class="alert alert-success mt-3" role="alert" ng-show="alertmessage">
                    {{alertmessage}}
                </div>
                <div class="row form-group mt-3">
                    <label class="col-md-12 control-lable" style="text-align:center"><h3>Manage Task</h3></label>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="taskName">Task*:</label>
                    <div class="col-md-8">
                        <input type="text" name="taskName" ng-model="taskName" class="form-control input-sm" required></input>
                        <!--
                        <span style="color:red" ng-show="taskForm.taskName.$dirty && taskForm.taskName.$error.required">
                            Please enter task name
                        </span>
                        -->
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="priority">Priority*:</label>
                    <div class="col-md-8">
                        <div class="slidecontainer">
                            0<input type="range" min="0" max="30" value="0" class="slider" name="priority" ng-model="priority">30
                        </div> 
                        <span style="color:blue"> 
                            priority is {{priority}}
                        </span>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="parentTask">Parent Task:</label>
                    <div class="col-md-8">
                        <select id="parentTask" name="parentTask" ng-model="parentTask">
                        	<option ng-repeat="task in tasks" value="{{task.taskId}}">{{task.task}}</option>
                        </select>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="startDate">Start Date*:</label>
                    <div class="col-md-8">
                        <div class="slidecontainer">
                            <input type="date" min="2018-01-01" max="2018-12-31" value="2018-01-01" name="startDate" ng-model="startDate" required format-date></input>
                            <span style="color:blue">
                                    Start date should be in 2018.
                            </span>
                        </div>
                    </div>
                </div>
                <div class="row form-group">
                    <label class="col-md-3 control-lable" style="text-align:right" for="endDate">End Date*:</label>
                    <div class="col-md-8">
                        <div class="slidecontainer">
                            <input type="date" min="2018-01-01" max="2018-12-31" value="2018-12-31" name="endDate" ng-model="endDate" required format-date></input>
                            <span style="color:blue">
                                    End date should be in 2018.
                            </span>
                        </div>
                    </div>
                </div>
                
                <hr/>
                <div class="row">
                    <div class="col-md-3"></div>
                    <div class="col-md-8">
                        <input ng-disabled="taskForm.taskName.$invalid " type="submit" class="btn btn-success" value="{{updateAddTest}}" ng-click="taskSubmitted()">
                        <button class="btn btn-danger" ng-click="resetForm()">Reset</button>
                    </div>
                </div>
            </form>
        </div>

        <!-- This is for view tasks page -->   
        <div class="col-md-8 col-sm-8 col-xs-8 col-xs-offset-2 col-md-offset-2 col-sm-offset-2 bg-white border rounded" ng-show="showViewPage">
            <div class="row mt-3">
                    <label class="col-md-12 control-lable" style="text-align:center"><h3>Manage Task</h3></label>
                    <table class="table table-borderless">
                        <tr>
                            <td class="col-xs-5" style="text-align: right">Task: <input type="text" ng-model="searchName"/></td>
                            <td class="col-xs-5">Parent Task: <input type="text" ng-model="searchParentName"/></td>
                        </tr>
                        <tr>
                            <td class="col-xs-5" style="text-align: right">Priority From: <input type="number" ng-model="searchPriorityMin" style="width:60px"/>&nbsp:&nbsp;Priority To: <input type="number" ng-model="searchPriorityMax" style="width:60px"/></td>
                            <td class="col-xs-5">Start Date: <input type="date" ng-model="searchStartDate" style="width:150px"/>&nbsp:&nbsp;End Date: <input type="date" ng-model="searchEndDate" style="width:150px"/></td>
                        </tr>
                    </table>
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th class="col-xs-2">Task</th>
                                <th class="col-xs-2">Parent</th>
                                <th class="col-xs-1">Priority</th>
                                <th class="col-xs-2">Start</th>
                                <th class="col-xs-2">End</th>
                                <th class="col-xs-2"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr ng-repeat="task in tasks|filter:taskFilter">
                                <td class="col-xs-2">{{task.task}}</td>
                                <td class="col-xs-2">{{task.parent}}</td>
                                <td class="col-xs-1">{{task.priority}}</td>
                                <td class="col-xs-2">{{task.startDate | dateformatter}}</td>
                                <td class="col-xs-2">{{task.endDate | dateformatter}}</td>
                                <td class="col-xs-2">
                                    <button class="btn btn-primary" ng-click="updateTask(task.taskId)" ng-disabled="task.taskended">Update</button>
                                    <button class="btn btn-danger" ng-click="endTask(task.taskId)" ng-disabled="task.taskended" title="End the task">End Task</button>
                                </td>
                            </tr>    
                        </tbody>
                    </table>
            </div>
        </div>
    </div>
    
    
</body>

</html>
