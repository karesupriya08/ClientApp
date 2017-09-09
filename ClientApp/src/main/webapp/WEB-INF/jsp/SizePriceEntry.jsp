<%-- 
    Document   : NormalOrderEntry
    Created on : Jul 6, 2017, 9:23:46 AM
    Author     : Supriya Kare
--%>



<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html data-ng-app="myApp" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Size Wise Price Entry</title>

        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
        <script src="<c:url value="/resources/js/app.js" />"></script>
        <script src="<c:url value="/resources/js/angular-ui-bootstrap-modal1.js" />"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-filter/0.5.16/angular-filter.js"></script>  
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link href="<c:url value="/resources/css/bootstrap.min.css" />" rel="stylesheet">
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/js/bootstrap-multiselect.js"></script>
        <link rel="stylesheet" type="text/css href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-multiselect/0.9.13/css/bootstrap-multiselect.css"/>
              <link href="<c:url value="/resources/css/bootstrap.css" />" rel="stylesheet">

        <link href="<c:url value="/resources/css/modalfieldset.css" />" rel="stylesheet">
        <script>

            var myApp = angular.module('myApp', ["ui.bootstrap.modal"]);
            myApp.controller("myCtrl", ['$scope', '$http', function ($scope, $http)
                {
                   
                    $scope.formdata = {};
                     $scope.isDisabled = true;
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

                                        $scope.data = response;

                                    });
                        }
                    };
                   

                    $scope.getSizePriceData = function (seas_code, serial,colour_code) {
                     
                        $http.get('getSizePriceData', {params: {seas_code: seas_code, serial: serial,colour_code:colour_code}}).
                                success(function (response) {

                                    $scope.sizepricedata = response;
                                   
                                      
                                    if ($scope.sizepricedata.flag === 'false')
                                    {
                                        alert($scope.sizepricedata.msg);
                                         $scope.isDisabled = true;
                                    }
                                    else
                                    {
                                        $scope.isDisabled = false;
                                    }

                                });
                          
                    };
                    $scope.getColours = function (seas_code, serial) {
                        if ($('#serial').val() !== '')
                        {
                            $http.get('getColours', {params: {seas_code: seas_code, serial: serial}}).
                                    success(function (response) {

                                        $scope.colours = response;
                                        
                                        if (Object.keys($scope.colours).length === 0)
                                        {
                                            alert("No such Serial found.....");
                                        }


                                    });
                        }
                        else
                        {
                            $scope.serial = '';
                        }
                    };

                    $scope.submit = function () {

                        var formdata = {
                            "seas_code": $('#seas_code').val(),
                            "serial": $('#serial').val(),
                            "buyer_code": $('#buyer_code').val(),
                            "style_no": $('#style_no').val(),
                            "b_style": $('#b_style').val(),
                            "sizeprice": $scope.sizepricedata.sizedata,
                            "colour": $('#colour_code').val()
                                   
                            
                             };
                             
                           
                        var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
                        var response = $http.post('saveSizePriceData', formdata, headers);
                        response.success(function (data, status, headers, config) {
                            $scope.result=data;
                          
                            alert( $scope.result.msg);
                            console.log('status', status);
                            console.log('data', status);
                            console.log('headers', status);

                        });
                        response.error(function (data, status, headers, config) {
                             $scope.result=data;
                            alert($scope.result.msg);
                        });


                    };
            

                }]);
         
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
            .help-block, .help-inline{
                color:red;
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
                <div class="panel-heading">Size Wise Price Entry Form</div>
                <div class="panel-body">
                    <form  class="form-horizontal" name="myform" data-ng-submit="submit()" nonvalidate>  
                        <div class="row">
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-2">Select Season</label>
                                    <div data-ng-init="populateSeasList()"  class="col-sm-5" >
                                        <select id="seas_code" ng-model="seas_code" name="seas_code" required ng-change="getSeasonDesc()"  class="form-control" >
                                            <option value="" >Select Season</option>
                                            <option data-ng-repeat="s in season" value="{{s.seas_code}}">{{s.seas_code}}</option>
                                        </select> 
                                         <span ng-show="myform.seas_code.$touched && myform.seas_code.$error.required" style="color: red">Required.</span>
                                    </div>

                                </div>
                            </div>
                            <div class="col-md-2" >
                                <div class="form-group">
                                    <input type="text"  id="seasonbean.seas_desc"  ng-init=" " readonly ng-model="seasonbean.seas_desc" ng-value="data.seas_desc" class="form-control" style="border:0px"/>

                                </div>
                            </div>
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Serial</label>
                                    <div class="col-sm-4"> 
                                        <input type="number" min="1" id="serial" name="serial"  data-ng-model="serial" required ng-blur="getColours(seas_code, serial)" class="form-control"/>
                                        <span ng-show="myform.serial.$touched && myform.serial.$error.required" style="color: red">Required.</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-sm-6"> 
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Select Colour</label>
                                    <div class="col-sm-5"> 
                                        <select ng-model="colour_code" id="colour_code" name="colour_code" required class="form-control" ng-change="getSizePriceData(seas_code,serial,colour_code)">
                                            <option value="" >Select Colour</option>
                                            <option data-ng-repeat="color in colours.colourList" value="{{color.colour_code}}">{{color.colour_code}}  {{color.colour_desc}}</option>
                                        </select>
                                       <span ng-show="myform.colour_code.$touched && myform.colour_code.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Buyer Code</label>
                                    <div class="input-group col-sm-4">
                                        <input class="form-control" id="buyer_code" type="text" readonly ng-model="buyer_code" ng-value="sizepricedata.buyer_code">

                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Style No.</label>
                                    <div class="input-group col-sm-5">
                                        <input class="form-control" id="style_no" type="text" readonly ng-model="style_no" ng-value="sizepricedata.style_no">

                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Colour Way</label>
                                    <div class="col-sm-4"> 
                                        <input type="text" name="colour_way" id="colour_way" readonly ng-model="colour_way" ng-value="sizepricedata.colour_way" class="form-control" />
                                        <span ng-show="Orderform.price.$touched && Orderform.price.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Order Quantity</label>
                                    <div class="col-sm-5"> 
                                        <input type="text"  id="order_qty" ng-model="order_qty" readonly name="order_qty" ng-value="sizepricedata.order_qty"  class="form-control"/>
                                      
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Buyer Style</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="b_style" data-ng-model="b_style" readonly ng-value="sizepricedata.b_style" class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Delivery Date</label>
                                    <div class="col-sm-4"> 
                                        <input type="date"  id="delv_date" name="delv_date"  readonly ng-model="delv_date" ng-value="sizepricedata.delv_date"   class="form-control"/>
                                      

                                    </div>
                                </div>
                            </div>

                        </div>

                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Garment Description</label>
                                    <div class="col-sm-4"> 
                                        <input type="text"  id="gar_desc" ng-model="gar_desc" readonly data-ng-value="sizepricedata.gar_desc" class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Main fabric</label>
                                    <div class="col-sm-4"> 
                                        <input type="text"  id="main_fab" ng-model="main_fab" readonly ng-value="sizepricedata.main_fab"  class="form-control"/>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Wov/Hos/Swe</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="wov_hos" name="wov_hos" readonly ng-model="wov_hos" ng-value="sizepricedata.wov_hos"  class="form-control"/>
                                   

                                    </div>
                                </div>
                            </div>
                           
                        </div>
                         <div class="table-responsive">          
                            <table class="table table-bordered">
                                <thead>
                                    <tr><th>Size Type</th>
                                        <th>Quantity</th>
                                        <th>Price</th></tr>
                                </thead>
                                
                                <tbody ng-repeat="s in sizepricedata.sizedata" >
                                    <tr >
                                        <td>{{s.SIZE_TYPE}}</td>
                                        <td>{{s.SIZE_QTY}}</td>

                                        <td><input type="text" name="price" id="price" ng-model="s.price" required />
                                          <span ng-show="myform.price.$touched && myform.price.$error.required" style="color: red">Required.</span></td>
                                      
                                    
                                    </tr>

                                </tbody>
                            </table>
                             
                        </div>
                        <input type="submit" value="Save" class="btn btn-primary" ng-disabled="isDisabled"/>

                    </form>
   </div>
            </div>

        </div>
       

    </body>
</html>
