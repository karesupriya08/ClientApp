<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html data-ng-app="myApp">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Catalog Entry Form</title>
        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
        <script src="<c:url value="/resources/js/app.js" />"></script>
        <script src="<c:url value="/resources/js/angular-ui-bootstrap-modal1.js" />"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-filter/0.5.16/angular-filter.js"></script>  
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <link href="<c:url value="/resources/css/bootstrap.min.css" />" rel="stylesheet">
        <link href="<c:url value="/resources/css/bootstrap.css" />" rel="stylesheet">

        <script>
            var myApp = angular.module('myApp', []);
            myApp.controller("myCtrl", function ($scope, $http)
            {
                $scope.checkCatalogExist = function (cat_name)
                {
                    if ($('#cat_name').val() === '')
                    {
                        cat_name = "";

                    }
                    else
                    {
                        $http.get('checkCatalog', {params: {cat_name: cat_name}}).
                                success(function (response) {

                                    $scope.catalog = response;
                                     if($scope.catalog.flag===true)
                                    {
                                        alert("This Catalog name is already used");
                                        $scope.cat_name="";
                                    }

                                });
                    }
                };
                $scope.submit=function()
                {
                    var cat_name=$scope.cat_name;
                    
                  $http.get('addCatalog',{params:{cat_name:cat_name}}). 
                          success(function (response) {

                                    $scope.addcatalog = response;
                                    if($scope.addcatalog.res===1)
                                    {
                                        alert('Catalog Added');
                                    }
                                    
                                   

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
                                <li><a href="DeliveryDateEntry">Delivery Date Modify</a></li>
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
                <div class="panel-heading">Catalog Entry Form</div>
                <div class="panel-body">
                    <form  name="myForm" novalidate class="form-horizontal" data-ng-submit="submit()">                      
                        <div class="form-group">
                            <label class="control-label col-sm-4">Catalog Name</label>
                            <div class="col-sm-4">    
                                <input type="text" id="cat_name" name="cat_name" ng-model="cat_name" ng-blur="checkCatalogExist(cat_name)" placeholder="Enter catalog name" required class="form-control"/>
                                <span ng-show="myForm.cat_name.$touched && myForm.cat_name.$invalid && myForm.cat_name.$error.required" style="color: red">Catalog Name is required.</span>
                            </div> 
                        </div>
                        <div class="form-group">
                            <div class="col-sm-4">    
                                <input type="submit" value="Add Catalog" class="btn btn-primary" ng-disabled="myForm.$invalid"/>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>


    </body>
</html>
