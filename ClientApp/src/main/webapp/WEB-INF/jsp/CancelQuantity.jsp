<%-- 
    Document   : CancelQuantity
    Created on : Jul 6, 2017, 10:33:38 AM
    Author     : Supriya Kare
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html data-ng-app="myApp">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cancel Quantity Form</title>
        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="https://rawgit.com/dwmkerr/angular-modal-service/master/dst/angular-modal-service.js"></script>

        <script>
            var myApp = angular.module('myApp', []);
            myApp.controller("myCtrl", function ($scope, $http)
            {
                 $scope.submit = function ()
                {
                    var formdata = {
                        "seas_code": $('#seas_code').val(),
                        "serial": $('#serial').val(),
                        "buyer_code": $('#buyer_code').val(),
                        "style_no": $('#style_no').val(),
                        "b_style": $('#b_style').val(),
                        "quota_cat": $('#quota_cat').val(),
                        "order_qty": $('#order_qty').val(),
                        "delv_date": $('#delv_date').val(),
                        "qty_can":$('#qty_can').val()
                    };
                                           
                        var response = $http.post('cancelQuantity', formdata);
                        response.success(function (data, status, headers, config)
                        {
                            $scope.cancel = response;
                            alert("Requested quantity has been cancelled....");
                            console.log('status', status);
                            console.log('data', data);
                            console.log('headers', status);

                        });
                        response.error(function (data, status, headers, config) {
                            alert("Exception details: " + JSON.stringify({
                                data: $scope.formdata //used formData model here

                            }));
                            console.log(formdata);

                        });

                };
                $scope.reset=function()
                {
                    $scope.season="";
                    $scope.seasondesc="";
                    $scope.serial=""
                    $scope.buyer_code="";
                    $scope.b_style="";
                    $scope.quota_cat="";
                    $scope.style_no="";
                    $scope.qty_can="";
                    $scope.delv_date="";
                    $scope.order_qty="";
                    
                };
                $scope.populateSeasList = function () {
                    $http({method: 'GET', url: 'getSeasList'}).
                            success(function (response) {
                                $scope.season = response;

                            });
                };
                $scope.getSeasonDesc = function ()
                {
                    var seas_code = document.getElementById("seas_code").value;
                    if (seas_code !== "")
                    {
                        $http.get('http://localhost:8080/ClientApp/getseasondesc', {params: {seas_code: seas_code}}).
                                success(function (response) {

                                    $scope.seasondesc = response;

                                });
                    }

                };
                $scope.myFunc = function (serial, seas_code) {
                    $http.get('getCancelDat', {params: {serial: serial, seas_code: seas_code}}).
                            success(function (data) {
                                $scope.order = data;
                                 if(Object.keys($scope.order).length===0)
                                {
                                    alert("No such Serial found.....");
                                }
                               
                              <%--  if($scope.order[0]==='false')
                                {
                                    alert("No such Serial found.....");
                                }--%>
                               
                            });
                };
                
               

            });
        </script>
        <style>
            #heading {
                background: #f85f64;
                color: #fff;
                text-align: center;
                text-transform: uppercase;
                font-weight: bold;
                padding: 1em;
                margin-left: 70px;
            }
        </style>
    </head>
    <body  data-ng-controller="myCtrl">
        <nav class="navbar navbar-inverse">
            <div class="container-fluid">
                <div class="navbar-header">
                    <button type="button" class="navbar-toggle" data-toggle="collapse" data-target="#myNavbar">
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>
                        <span class="icon-bar"></span>                        
                    </button>
                    <a class="navbar-brand" href="#">Client Module</a>
                </div>
                <div class="collapse navbar-collapse" id="myNavbar">
                    <ul class="nav navbar-nav">
                        <li class="active"><a href="index.jsp">Home</a></li>
                        <li class="dropdown">
                            <a class="dropdown-toggle" data-toggle="dropdown" href="#">Master <span class="caret"></span></a>
                            <ul class="dropdown-menu">
                                <li><a href="DeliveryDateEntry">Normal Order Entry</a></li>
                                <li><a href="empform">Add Order</a></li>
                                <li><a href="viewemp">View Order</a></li>
                            </ul>
                        </li>
                        <li><a href="#">Entry</a></li>
                        <li><a href="#">Printing</a></li>
                    </ul>
                    <ul class="nav navbar-nav navbar-right">

                        <li><a href="#"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
                    </ul>
                </div>
            </div>
        </nav>  
        <div>
            <div class="panel panel-info" style='width:70%;margin-left: 10%'>
                <div class="panel-heading">Cancel Quantity Form</div>
                <div class="panel-body">
                    <form  name="myForm" novalidate class="form-horizontal" >                      
                        <div class="form-group">

                            <label class="control-label col-sm-3">Select Season</label>
                            <div data-ng-init="populateSeasList()"  class="col-sm-3" >
                                <select id="seas_code" ng-model="seas_code"  ng-change="getSeasonDesc()" required class="form-control" >
                                    <option value="" >Select Season</option>
                                    <option data-ng-repeat="s in season" value="{{s.seas_code}}">{{s.seas_code}}</option>
                                </select>                           
                            </div>
                            <span ng-show="myForm.seas_code.$touched || myForm.seas_code.$dirty || myForm.seas_code.$error.required">The name is required.</span>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-sm-3">Season Description</label>
                            <div class="col-sm-2"> 
                                <input type="text"  id="seasonbean.seas_desc"  ng-init=" " ng-model="seasonbean.seas_desc" ng-value="seasondesc" class="form-control"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-sm-3">Serial</label>
                            <div class="col-sm-2">    
                                <input type="number" min="1" id="serial" name="serial" ng-model="serial"  placeholder="Enter Serial" required class="form-control"/>

                                <span ng-show="myForm.serial.$touched && myForm.serial.$invalid && myForm.serial.$error.required" style="color: red">Serial No.is required.</span>
                            </div> 
                        </div>
                        <div class="form-group"> 
                            <div class="col-sm-offset-2 col-sm-10">
                                <button ng-click="myFunc(serial, seas_code)" ng-disabled="myForm.serial.$error.required" class="btn btn-primary">Get Data</button>         
                            </div>    
                        </div>
                        <div ng-repeat="o in order"> 
                            <div class="form-group">
                                <label class="control-label col-sm-3">Buyer Code</label>
                                <div class="col-sm-2">   
                                    <input type="text" name="buyer_code" id="buyer_code" ng-model="buyer_code" readonly="true" ng-value="o.buyer_code" class="form-control"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3">Style No </label>
                                <div class="col-sm-2">   
                                    <input type="text" name="style_no" id="style_no" ng-model="style_no" readonly="true" ng-value="o.style_no" class="form-control"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3">Buyer Style </label>
                                <div class="col-sm-2">   
                                    <input type="text" name="b_style" id="b_style" ng-model="b_style" readonly="true" ng-value="o.b_style" class="form-control"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3">Quota Cat </label>
                                <div class="col-sm-2">   
                                    <input type="text" name="quota_cat" id="quota_cat" ng-model="quota_cat" readonly="true" ng-value="o.quota_cat" class="form-control"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3">Order Quantity </label>
                                <div class="col-sm-2">   
                                    <input type="number" name="order_qty" id="order_qty" ng-model="order_qty" readonly="true" ng-value="o.order_qty" class="form-control"/>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-3">Delivery Date </label>
                                <div class="col-sm-2">   
                                    <input type="text" name="delv_date" id="delv_date" ng-model="delv_date" readonly="true" ng-value="o.delv_date|date:'dd-MMM-y'" class="form-control"/>
                                </div>
                            </div>
                     
                       
                           </div>
                         <div class="form-group">
                            <label class="control-label col-sm-3">Cancel Quantity </label>
                            <div class="col-sm-2">   
                                <input type="number" min="1" name="qty_can" id="qty_can" ng-model="qty_can"  class="form-control" required />
                               <span ng-show="myForm.qty_can.$touched && myForm.qty_can.$invalid && myForm.qty_can.$error.required" style="color: red">Cancel Quantity is required.</span>

                            </div>
                        </div>
                         <div class="form-group">
                             <div class="control-label col-sm-3">  <button ng-click="submit()"  ng-disabled="myForm.$invalid " class="btn btn-primary">Cancel Quantity</button></div>
                                <div class="col-sm-2">   
                                    <button ng-click="reset()"  class="btn btn-primary">Reset</button>
                                </div>
                            </div>
                     
                </div>
                </form>
            </div></div>
    </div>

</body>
</html>
