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
        <title>Invoice Cancel Order</title>
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
                        "qty_can": $('#qty_can').val()
                    };

                    var response = $http.post('cancelQuantity', formdata);
                    response.success(function (data, status, headers, config) {
                        $scope.cancelQuantity = response;
                        console.log('status', status);
                        console.log('data', status);
                        console.log('headers', status);

                    });
                    response.error(function (data, status, headers, config) {
                        alert("Exception details: " + JSON.stringify({
                            data: $scope.formdata //used formData model here

                        }));
                        console.log(formdata);

                    });

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
                 $scope.checkSerial = function (serial,seas_code) {
                     if($scope.serial>0)
                     {
                     $http.get('checkSerial', {params: {serial:serial,seas_code: seas_code}}).
                            success(function (response) {
                               
                                $scope.resSerial = response;
                                if($scope.resSerial.cnt===1){
                                 alert( "No such serial found");
                                 $scope.serial="";
                             }
                            });
                        }
                };
                $scope.getShipNo=function(seas_code,serial,colour)
                {
                      $http.get('getShipNo', {params: {serial:serial,seas_code: seas_code,colour:colour}}).
                            success(function (response) {
                               
                                $scope.shipno = response;
                               
                            });
                };
                $scope.checkShipStatus=function(seas_code,serial,colour,ship_no)
                {
                    $http.get('checkShipStatus', {params: {serial:serial,seas_code: seas_code,colour:colour,ship_no:ship_no}}).
                            success(function (response) {
                               
                                $scope.shipdata = response;
                                if($scope.shipdata.flag==='C')
                                {
                                    alert($scope.shipdata.msg);
                                }
                                else if($scope.shipdata.flag==='Y')
                                {
                                     alert($scope.shipdata.msg);
                                }
                                else
                               { }
                               
                            });
                };
                $scope.submit=function()
                {
                    var fomdata=
                    {
                        "serial" : $scope.serial,
                        "season" : $scope.seas_code,
                        "colour" : $scope.colour,
                        "ship_no" : $scope.ship_no
                    };
                    
                          $http.post('cancelInvoice', fomdata).
                            success(function (response) {
                               
                                $scope.cancelInvoice = response;
                                alert($scope.cancelInvoice.msg);
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
                <div class="panel-heading">Invoice Cancel Order</div>
                <div class="panel-body">
                    <form  name="myForm" novalidate class="form-horizontal" ng-submit="submit()" >                      
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
                            <div class="col-sm-4"> 
                                <input type="text"  id="seasonbean.seas_desc"  ng-init=" " ng-model="seasonbean.seas_desc" ng-value="seasondesc" class="form-control"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <label class="control-label col-sm-3">Serial</label>
                            <div class="col-sm-2">    
                                <input type="number" min="1" id="serial" name="serial" ng-model="serial" ng-blur="checkSerial(serial,seas_code)" placeholder="Enter Serial" required class="form-control"/>

                                <span ng-show="myForm.serial.$touched && myForm.serial.$invalid && myForm.serial.$error.required" style="color: red">Serial No.is required.</span>
                            </div> 
                        </div>
                          <div class="form-group">
                               <label class="control-label col-sm-3">Select Colour</label>
                        <div class="col-sm-3"> 
                            <select ng-model="colour" name="colour" class="form-control" ng-change="getShipNo(seas_code,serial,colour)" required>
                                <option disabled value="" >Select Colour</option>
                                <option data-ng-repeat="color in resSerial.colorlist" value="{{color.COLOUR_CODE}}">{{color. COLOUR_DESC}}</option>
                            </select>
                              <span ng-show="myForm.colour.$touched && myForm.colour.$invalid && myForm.colour.$error.required" style="color: red">ship No.is required.</span>
                        </div>
                          </div>
                         <div class="form-group">
                            <label class="control-label col-sm-3">Ship No.</label>
                            <div class="col-sm-2">    
                                <select ng-model="ship_no" name="ship_no"  class="form-control" ng-change="checkShipStatus(seas_code,serial,colour,ship_no)" required>
                                <option disabled value="" >Select Ship NO.</option>
                                <option data-ng-repeat="ship in shipno.shiplist" value="{{ship.SHIP_NO}}">{{ship.SHIP_NO}}</option>
                            </select>
                                <span ng-show="myForm.ship_no.$touched && myForm.ship_no.$invalid && myForm.ship_no.$error.required" style="color: red">ship No.is required.</span>
                            </div> 
                        </div>
                           <div class="form-group">
                            <label class="control-label col-sm-3">Buyer Code</label>
                            <div class="col-sm-2"> 
                                <input type="text"  id="buyer_code"  ng-model="buyer_code" ng-value="shipdata.buyer_code"  readonly class="form-control"/>
                                
                            </div>
                        </div>
                         <div class="form-group">
                            <label class="control-label col-sm-3">Style No.</label>
                            <div class="col-sm-2"> 
                                <input type="text"  id="style_no"  ng-model="style_no" ng-value="shipdata.style_no"  readonly class="form-control"/>
                            </div>
                        </div>
                          <div class="form-group">
                            <label class="control-label col-sm-3">Invoice Quantity</label>
                            <div class="col-sm-2"> 
                                <input type="text"  id="order_qty"  ng-model="order_qty" ng-value="shipdata.order_qty"  readonly class="form-control"/>
                            </div>
                        </div>
                        <div class="form-group">
                            <div class="col-sm-offset-2 col-sm-10">
                                 <input type="submit" value="Cancel Invoice" class="btn btn-primary" ng-disabled="myForm.$pristine||myForm.$invalid" />
                            </div>
                        </div>
                        
                </div>
                </form>
            </div></div>
    </div>

</body>
</html>
