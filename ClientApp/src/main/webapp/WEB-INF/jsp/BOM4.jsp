<%-- 
    Document   : BOM4
    Created on : Sep 8, 2017, 9:14:38 AM
    Author     : Supriya Kare
--%>

<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html data-ng-app="myApp" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>PO Approved Module</title>
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
                    $scope.colourdisable = true;
                    $scope.sizedisable = true;
                    $('#po').hide();
                    $('#poorderdata').hide();
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
                        $http.get('getStyleNoList', {params: {seas_code: seas_code, buyer_code: buyer_code}}).
                                success(function (response) {
                                    $scope.style = response;
                                });
                        $scope.populatecodeList();
                    };
                    $scope.populatecodeList = function () {
                        var seas_code = $scope.seas_code;
                        console.log('populatecodeList');
                        console.log(seas_code);
                        $http.get('getCodeListforBom4', {params: {seas_code: seas_code}}).
                                success(function (response)
                                {
                                    $scope.codelist = response;

                                });
                    };
                    $scope.getColourBom4 = function ()
                    {
                        $http.get('getColourBom4').
                                success(function (response)
                                {
                                    $scope.colours = response;
                                });
                    };
                    $scope.setItemCode=function(codelists)
                    {
                        $scope.item_code=codelists;
                    };
                    $scope.getsize=function()
                    {
                        var size=$scope.size;
                        
                        if($('#size').val().length===0)
                        {
                           $scope.size= "N-A";
                            $scope.sizedisable = true;
                             $scope.getCatalogList();
                             $scope.getUOMList();
                        }
                    };
                     $scope.getCatalogList = function () {

                        $http.get('getCatalogList').
                                success(function (response) {
                                    $scope.cataloglist = response;
                                });
                    };
                     $scope.getUOMList = function () {

                        $http.get('getUOMList').
                                success(function (response) {
                                    $scope.uomlist = response;
                                });
                    };
                    $scope.checkcatalog=function()
                    {
                        
                    };
                    $scope.checkFabCode = function ()
                    {
                        var seas_code = $scope.seas_code;
                        var item_code = $('#item_code').val();
                        $http.get('checkItemCode', {params: {item_code: item_code, seas_code: seas_code}}).
                                success(function (response)
                                {
                                    $scope.ckeckres = response;
                                    $scope.htype = $scope.ckeckres.htype;
                                    if ($scope.ckeckres.colourenableflag === 'true')
                                    {
                                        // $('#colour_code').focus();
                                        $scope.colourdisable = false;
                                          $scope.sizedisable = false;
                                    }
                                     if ($scope.ckeckres.colourenableflag === 'false')
                                    {
                                        $scope.colour_code = "28";
                                        $scope.colourdisable = true;
                                        $scope.sizedisable = false;
                                        // $scope.colour_code = $scope.ckeckres.colour;
                                    }

                                    if ($scope.ckeckres.incorrectflag === 'true' )
                                    {
                                        alert($scope.ckeckres.incorrectflagmsg);
                                        //  $('#item_code').focus();
                                    }
                                    if ($scope.ckeckres.changeitemcodeflag === 'true')
                                    {
                                        alert($scope.ckeckres.changeitemcodeflagmsg);
                                        //  $('#item_code').focus();
                                    }
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
                        <div class="col-md-5" >
                            <div class="form-group">
                                <label class="control-label col-sm-5">Style No.</label>
                                <div  class="col-sm-6" >
                                    <select id="style_no" data-ng-model="style_no"   class="form-control" ng-blur="getColourBom4()">
                                        <option value="" >Select Style</option>
                                        <option data-ng-repeat="st in style" value="{{st.STYLE_NO}}">{{st.STYLE_NO}}</option>
                                    </select>                           
                                </div>  
                            </div>
                        </div>
                    </div>
                    <div class="row">
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="control-label col-sm-1">Item Code</label>
                                <div class="input-group col-sm-6">
                                    <input class="form-control" id="item_code" type="text"  ng-model="item_code" ng-value="codelists"  ng-blur="checkFabCode()" >
                                    <div class="input-group-btn">
                                        <select ng-model="codelists" id="codelists" name="codelists" required class="form-control" ng-change="setItemCode(codelists)" ng-blur="checkFabCode()">
                                            <option value="" >--Select Colour--</option>
                                            <option data-ng-repeat="code in codelist" value="{{code.FAB_CODE}}">{{code.FAB_CODE}}&#160;&#160;&#160;{{code.FAB_DESC}}  {{code.MFAB_DESC}} </option>
                                        </select>
                                        {{codelists.FAB_DESC}}
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-4"> 
                            <div class="form-group">
                                <label class="control-label col-sm-1">Colour</label>
                                <div class="input-group col-sm-5" >
                                    <select ng-model="colour_code" id="colour_code" name="colour_code" required class="form-control"  ng-disabled="colourdisable">
                                        <option value="" >--Select Colour--</option>
                                        <option data-ng-repeat="color in colours" value="{{color.COLOUR_CODE}}">{{color.COLOUR_CODE}}  &#160; &#160;{{color.COLOUR_DESC}}</option>
                                    </select>
                                    {{colour_code.COLOUR_DESC}}
                                    <span ng-show="myform.colour_code.$touched && myform.colour_code.$error.required" style="color: red">Required.</span>
                                </div>

                            </div>
                        </div>
                        <div class="col-md-4">
                            <div class="form-group">
                                <label class="control-label col-sm-1">Size</label>
                                <div class="input-group col-sm-4">
                                    <input class="form-control" id="size" type="text"  ng-model="size" ng-disabled="sizedisable" ng-blur="getsize()">
                                </div>
                            </div>
                        </div>
                    </div>
                     <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="control-label col-sm-1">Catalog</label>
                            <div class="input-group col-sm-5">
                                <div class="input-group-btn">
                                    <select  id="catalog" data-ng-model="catalog" class="form-control" ng-blur="checkcatalog()" >
                                        <option value="" >Select Buyer</option>
                                        <option data-ng-repeat="cat in cataloglist" value="{{cat.CAT_NAME}}">{{cat.CAT_NAME}}</option>
                                    </select> 
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="control-label col-sm-1">UOM</label>
                            <div class="input-group col-sm-5">

                                <div class="input-group-btn">
                                    <select  id="uom" data-ng-model="uom" class="form-control"  >
                                        <option value="" >--Select UOM--</option>
                                        <option data-ng-repeat="uom in uomlist" value="{{uom.UOM}}">{{uom.UOM}}</option>
                                    </select> 
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                   
                    <input type="reset" value="Reset" class="btn btn-primary" />
                </form>
            </div>
        </div>
    </div>
 http://quantlabs.net/blog/2010/06/citi-bank-java-interview-questions-with-answers-pays-primo-with-no-onsite-interview/
</body>
</html>
