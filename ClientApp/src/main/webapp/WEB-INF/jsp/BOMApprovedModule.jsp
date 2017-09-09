<%-- 
    Document   : BOMApprovedModule
    Created on : Sep 7, 2017, 3:27:54 PM
    Author     : Supriya Kare
--%>

<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html data-ng-app="myApp" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>BOM Approved Module</title>
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
                    $('#po').hide();
                    $('#datediv').hide();
                    $scope.populateSeasList = function () {
                        $http({method: 'GET', url: 'getSeasList'}).
                                success(function (response) {
                                    $scope.season = response;

                                });
                        $scope.getBuyerCodeList();
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
                    $scope.getBuyerCodeList = function () {
                        $http.get('getBuyerCodeList').
                                success(function (response) {
                                    $scope.buyer = response;
                                });
                    };
                    $scope.getStyleNo = function (seas_code, buyer_code) {
                        $http.get('getStyleNo', {params: {seas_code: seas_code, buyer_code: buyer_code}}).
                                success(function (response) {
                                    $scope.style = response;
                                });
                    };
                    $scope.getBomappdata = function (seas_code, style_no, buyer_code,fabradio)
                    {
                        $http.get('getBomappdata', {params: {seas_code: seas_code, style_no: style_no, buyer_code: buyer_code,fabradio:fabradio}}).
                                success(function (response) {
                                    $scope.podata = response;
                                    if ($scope.podata.poentryflag === 'false')
                                    {
                                        alert($scope.podata.msg);
                                    }
                                    else
                                    {
                                        $('#po').show();
                                    }
                                });
                    };
                    $scope.getpoorderdata = function (po)
                    {
                        var serial = po.serial;
                        var colour = po.colour;
                        var seas_code = $scope.seas_code;
                        console.log(serial + " " + colour);
                        $http.get('getpoorderdata', {params: {seas_code: seas_code, serial: serial, colour: colour}}).
                                success(function (response) {
                                    $('#poorderdata').show();
                                    $scope.poorderdata = response;

                                });
                    };
                    $scope.po = [];
                    $scope.approved = function (podata)
                    {
                        po = podata;
                        $scope.showModalforAlert = true;
                    };
                    $scope.yesapproved = function ()
                    {
                        console.log(po);
                        var formdata = {
                            'seas_code': $scope.seas_code,
                            'poorderdata': $scope.poorderdata.poorderdatalist
                        };
                        $http.post('saveApproveddata', formdata).
                                success(function (response) {
                                    $scope.res = response;
                                });
                        $scope.showModalforAlert = false;
                    };
                    $scope.close = function ()
                    {
                        $scope.showModalforAlert = false;
                    };
                    $scope.getoptions = function (optradio)
                    {
                        if (optradio === 'st')
                        {
                            $('#stylediv').show();
                            $('#datediv').hide();
                        }
                        else
                        {
                            $('#stylediv').hide();
                            $('#datediv').show();
                        }
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
            .modal{
                width:60%;
                height: 30%;
                left:400px;
                top:4%
            }
            .modal-body{
                max-height: 200px;
            }
            .modal-header{
                height:13%;
            }
        </style>
    </head>
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
            <div class="panel-heading">PO Approved Module</div>
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
                    </div>
                    <div class="row">
                        <div class="col-md-6" >
                            <div class="form-group">
                                <label class="control-label col-sm-5">Buyer Code</label>
                                <div class="input-group col-sm-5">

                                    <div class="input-group-btn">
                                        <select  id="buyer_code" data-ng-model="buyer_code" class="form-control" ng-change="getStyleNo(seas_code, buyer_code)" >
                                            <option value="" >Select Buyer</option>
                                            <option data-ng-repeat="b in buyer" value="{{b.buyer_code}}">{{b.buyer_code}}</option>
                                        </select> 
                                    </div>
                                </div>
                            </div>
                        </div>
                         <div class="col-md-5">
                            <div class="form-group">
                                 <fieldset>
                                    <label class="radio-inline">
                                        <input type="radio" name="fabradio"  required ng-model="fabradio" value="false" >Fabric
                                    </label>
                                    <label class="radio-inline">
                                        <input type="radio"  name="fabradio" required ng-model="fabradio" value="true" checked >Non fabric
                                    </label>
                                 </fieldset>
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-5">
                            <div class="form-group">
                                <label class="control-label col-sm-4">Options</label>
                                <fieldset>
                                    <label class="radio-inline">
                                        <input type="radio" name="optradio" ng-click="getoptions(optradio)" required ng-model="optradio" value="st" >Style
                                    </label>
                                    <br/>
                                    <label class="radio-inline">
                                        <input type="radio"  name="optradio" ng-click="getoptions(optradio)" required ng-model="optradio" value="dt" checked >Date
                                    </label>
                                </fieldset>
                            </div>
                        </div>
                        <div class="col-md-5" id="stylediv" >
                            <div class="form-group">
                                <label class="control-label col-sm-5">Style No.</label>
                                <div  class="col-sm-6" >
                                    <select id="style_no" data-ng-model="style_no"   class="form-control" ng-change="getBomappdata(seas_code, style_no, buyer_code,fabradio)">
                                        <option value="" >Select Style</option>
                                        <option data-ng-repeat="st in style" value="{{st.style_no}}">{{st.style_no}}</option>
                                    </select>                           
                                </div>  
                            </div>
                        </div>
                        <div class="col-md-5" id="datediv" >
                            <div class="form-group">
                                <label class="control-label col-sm-5"> Start Date </label>
                                <div class="col-sm-6"> 
                                    <input type="date" ng-model="start_date" id="start_date" name="start_date" class="form-control" required/>
                                    <span ng-show="Orderform.order_date.$touched && Orderform.order_date.$invalid && Orderform.order_date.$error.required" style="color: red">Required.</span>
                                </div>
                            </div>
                            <div class="form-group">
                                <label class="control-label col-sm-5"> End Date </label>
                                <div class="col-sm-6"> 
                                    <input type="date" ng-model="end_date" id="end_date" name="end_date" class="form-control" required/>
                                    <span ng-show="Orderform.order_date.$touched && Orderform.order_date.$invalid && Orderform.order_date.$error.required" style="color: red">Required.</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row" id="po">
                        <div class="table-responsive">          
                            <table class="table table-bordered">
                                <thead>
                                    <tr><th>Serial</th>
                                        <th>Colour</th>
                                        <th>Colour Desc</th></tr>
                                </thead>

                                <tbody ng-repeat="po in podata.podata" >
                                    <tr >
                                        <td ng-click="getpoorderdata(po)">{{po.serial}}</td>
                                        <td ng-click="getpoorderdata(po)">{{po.colour}}</td>
                                        <td ng-click="getpoorderdata(po)">{{po.colour_desc}}</td>
                                        <td><input type="button" value="Approve" ng-click="approved(po)" /></td>

                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    P.O. No. {{poorderdata.pono}}
                    <div class="row" id="poorderdata">
                        <div class="table-responsive">          
                            <table class="table table-bordered">
                                <thead>
                                    <tr>
                                        <th>Season</th>
                                        <th>Serial</th>
                                        <th>Colour</th>
                                        <th>Size Type</th>
                                        <th>Size Qty</th>
                                        <th>Style_No</th>
                                        <th>Buyer Code</th>
                                        <th>Date</th>
                                        <th>Time</th>
                                        <th>Init</th>
                                    </tr>
                                </thead>

                                <tbody ng-repeat="porder in poorderdata.poorderdatalist" >
                                    <tr >
                                        <td>{{porder.season}}</td>
                                        <td>{{porder.serial}}</td>
                                        <td>{{porder.colour}}</td>
                                        <td>{{porder.size_type}}</td>
                                        <td>{{porder.size_qty}}</td>
                                        <td>{{porder.style_no}}</td>
                                        <td>{{porder.buyer_code}}</td>
                                        <td>{{porder.m_date_time}}</td>
                                        <td>{{porder.Time}}</td>
                                        <td>{{porder.init}}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <input type="reset" value="Reset" class="btn btn-primary" />
                </form>
            </div>
        </div>
    </div>
    <div modal="showModalforAlert" close="close()">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" ng-click="cancelCopyModal()" aria-hidden="true">&times;</button>
            <h5 class="modal-title">Alert</h5>
        </div>
        <div class="modal-body">
            <p >Are you sure you want to approve the selected item</p>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn" ng-click="yesapproved()" >Yes</button>
            <button type="button" class="btn" ng-click="close()">No</button>
        </div>
    </div>
</body>
</html>
