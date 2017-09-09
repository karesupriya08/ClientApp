<%-- 
    Document   : Demo
    Created on : Jul 10, 2017, 10:37:25 AM
    Author     : Supriya Kare
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html data-ng-app="myApp">
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
         <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="https://rawgit.com/dwmkerr/angular-modal-service/master/dst/angular-modal-service.js"></script>
        <script>
            var myApp = angular.module('myApp', []);
            myApp.controller("myCtrl", ['$scope', '$http', function ($scope, $http)
                {
                    $scope.list = [];
                    $scope.Season = {}; //should set object on init.

                    $scope.submit = function () {
                        var Season = {
                            "seas_code": $scope.seas_code,
                            
                            "b_style":$scope.b_style
                            

                        };
                        var response = $http.post('AddOrder', Season);
                        response.success(function (data, status, headers, config) {
                            $scope.list.push(data);
                            alert(data);
                        });
                        response.error(function (data, status, headers, config) {
                            alert("Exception details: " + JSON.stringify({
                                data: $scope.order //used formData model here
                            }));
                        });


                    };
                }]);

        </script>
    </head>
    <body>
    <body  >
        <form  data-ng-submit="submit()" name="myForm" data-ng-controller="myCtrl">
            Seasoncode   <input type="text" ng-model="seas_code" /></br>
            Buyer style <input type="text" ng-model="b_style" /></br>
            <h4>You submitted below data through post:</h4>
            <pre>Form data ={{list}}</pre>
            <input type="submit"/>
        </form>
        
        <form  role="form">
            <div class="form-inline" >
  <div class="form-group">
    <label  for="exampleInputEmail2">Email address</label>
    <input type="email" class="form-control" id="exampleInputEmail2" placeholder="Enter email">
  </div>
  <div class="form-group">
    <div class="input-group">
      <div class="input-group-addon">@</div>
      <input class="form-control" type="email" placeholder="Enter email">
    </div>
  </div>
  <div class="form-group">
    <label  for="exampleInputPassword2">Password</label>
    <input type="password" class="form-control" id="exampleInputPassword2" placeholder="Password">
  </div>
  
            </div>
              <div class="form-inline" >
  <div class="form-group">
    <label  for="exampleInputEmail2">Email address</label>
    <input type="email" class="form-control" id="exampleInputEmail2" placeholder="Enter email">
  </div>
  <div class="form-group">
    <div class="input-group">
      <div class="input-group-addon">@</div>
      <input class="form-control" type="email" placeholder="Enter email">
    </div>
  </div>
  <div class="form-group">
    <label for="exampleInputPassword2">Passworddddddddd</label>
    <input type="password" class="form-control" id="exampleInputPassword2" placeholder="Password">
  </div>
 
            </div>
            <div class="container-fluid">
           <div class="row">
        <div class="col-md-4" >
        <div class="form-group">
                            <label class="control-label col-sm-5">Print</label>
                            <div class="col-sm-2"> 
                                <input type="text"  id="print" ng-model="print" ng-value="order.print"  class="form-control"/>
                              
                            </div>
                        </div>
      </div>
        <div class="col-md-2">
        Level 2: .col-md-6
      </div>
      <div class="col-md-6" >
       <div class="form-group">
                            <label class="control-label col-sm-5">Print</label>
                            <div class="col-sm-2"> 
                                <input type="text"  id="print" ng-model="print" ng-value="order.print"  class="form-control"/>
                              
                            </div>
                        </div>
      </div>
           </div></div>
</form>

    </body>
</html>
