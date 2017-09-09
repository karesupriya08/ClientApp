
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html data-ng-app="myApp">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Delivery Date Modification Module</title>
        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="https://rawgit.com/dwmkerr/angular-modal-service/master/dst/angular-modal-service.js"></script>

        <script>
            var myApp = angular.module('myApp', []);
            myApp.controller("myCtrl", function ($scope, $http)
            {
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
                $scope.myFunc = function (serial) {
                    $http.get('getalldata1', {params: {serial: serial}}).
                            success(function (data) {
                                $scope.order = data;
                            });
                };
                $scope.Mod_Date = function (serial, delv_date)
                {
                    var newdate = document.getElementById("delv_date").value;
                    $http.get('http://localhost:8080/ClientApp/modDelivery_date', {params: {serial: serial, delv_date: newdate}}).
                            success(function (data) {

                                $scope.order = data;
                                alert(data);
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
            <li><a href="trycopy">Delivery Date Modify</a></li>
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
      <div class="panel-heading">Delivery Date Modification Form</div>
      <div class="panel-body">
        <form  name="myForm" novalidate class="form-horizontal"  class="form-inline" role="form">
        
           
         
            <div class="form-group">
                
                <label class="control-label col-sm-2">Select Season</label>
                <div data-ng-init="populateSeasList()"  class="col-sm-3" >
                    <select id="seas_code" ng-model="seas_code"  ng-change="getSeasonDesc()" required class="form-control" >
                        <option value="" >Select Season</option>
                        <option data-ng-repeat="s in season" value="{{s.seas_code}}">{{s.seas_code}}</option>
                    </select>                           
                </div>
                <span ng-show="myForm.seas_code.$touched || myForm.seas_code.$dirty || myForm.seas_code.$error.required">The name is required.</span>
            </div></br>
            <div class="form-group">
                <label class="control-label col-sm-2">Season Description</label>
                <div class="col-sm-2"> 
                    <input type="text"  id="seasonbean.seas_desc"  ng-init=" " ng-model="seasonbean.seas_desc" ng-value="seasondesc" class="form-control"/>
                </div>
            </div>
            <div class="form-group">
                <label class="control-label col-sm-2">Serial</label>
                <div class="col-sm-2">    
                    <input type="number" min="1" name="serial" ng-model="serial"  placeholder="Enter Serial" required class="form-control"/>

                    <span ng-show="myForm.serial.$touched && myForm.serial.$invalid && myForm.serial.$error.required" style="color: red">Serial No.is required.</span>
                </div> 
            </div>
            <div class="form-group"> 
                <div class="col-sm-offset-2 col-sm-10">
                    <button ng-click="myFunc(serial)" ng-disabled="myForm.serial.$error.required" class="btn btn-primary">Get Data</button>         
                </div>    
            </div>
            <div class="form-group"> 
                <div class="col-sm-offset-2 col-sm-10">
                    Results:
                    <table class="table">
                        <!-- assuming our search returns an array of users matching the search -->
                        <tbody ng-repeat="o in order">
                            <tr><td> Buyer Code:  {{o.buyer_code}}</td></tr>
                            <tr> <td>Style No:  {{o.style_no}}</td></tr>
                            <tr><td>order Quantity {{o.order_qty}}</td></tr>
                            <tr><td> Delivery Date {{o.delv_date|date:'dd-MMM-y' }}</td></tr>

                        </tbody>

                    </table></td></tr>
                </div></div>
            <div class="form-group">
                <label class="control-label col-sm-2"> New Delivery Date </label>
                <div class="col-sm-2"> 
                    <input type="date" ng-model="delv_date" id="delv_date" required class="form-control"/>
                    <td> <span ng-show="myForm.delv_date.$touched && myForm.delv_date.$invalid && myForm.delv_date.$error.required" style="color: red"> date is required.</span>
                </div></div>
            <div class="form-group">
                <div class="col-sm-offset-2 col-sm-10">
                    <button ng-click="Mod_Date(serial, delv_date)" ng-disabled="myForm.serial.$error.required" class="btn btn-primary">Modify Date</button>
                    
                </div>
            </div>
           
        </form>
             </div></div>
        </div>
         <div class="form-group">
                            <label class="control-label col-sm-2">Buyer Code</label>
                            <div class="input-group col-sm-3">

                                <input class="form-control" type="text" value="" placeholder="Enter New Buyer Code or select from list" ng-model="buyer_code" ng-value="{{b.buyer_code}}">
                                <div class="input-group-btn">
                                    <button type="button" class="btn btn-primary dropdown-toggle" data-toggle="dropdown" ng-click="getBuyerCodeList()" aria-haspopup="true" aria-expanded="false">
                                        <span id="mydropdowndisplay">Select Buyer</span> <span class="caret"></span></button>
                                    <ul class="dropdown-menu" id="buyer_code" ng-model="buyer_code" style="width: 100px; height: 200px; overflow: auto" >
                                        <li data-ng-repeat="b in buyer" value="{{b.buyer_code}}"><a href="#">{{b.buyer_code}}</a></li>
                                       
                                    </ul>
                                   
                                    <input type="hidden" id="mydropwodninput" name="category">
                                </div><!-- /btn-group -->
                            </div></div>
         <div class="row" style="border:1px">
                            <div class="col-sm-4">
                                <div class="row header">
                                    <div class="col-xs-4 text-center">
                                        <label class="control-label col-sm-3">COLOUR</label> 
                                    </div>
                                </div></div>
                            <div class="col-sm-4"><div class="row header">
                                    <div class="col-xs-4 text-center">
                                        <label class="control-label col-sm-5">COLOUR NAME</label> 
                                    </div></div></DIV>
                            <div class="col-sm-4"><div class="row header">
                                    <div class="col-xs-4 text-center">
                                        <label class="control-label col-sm-3">CONTENT</label>
                                    </div></div>
                            </div>
                        </div>

    </body>
</html>
