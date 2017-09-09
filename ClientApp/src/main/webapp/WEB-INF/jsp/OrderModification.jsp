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
        <title>Order Modification  Form</title>

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
                    $scope.myFunc = function (serial) {
                        $http.get('getalldata1', {params: {serial: serial}}).
                                success(function (data) {
                                    $scope.orderdata = data;
                                });
                    };
                 
                    $scope.getOrderModdata = function (seas_code, serial ) {
                        $http.get('getOrderModdata', {params: {seas_code: seas_code, serial:serial}}).
                                success(function (response) {

                                    $scope.ordermod = response;
                                    if( $scope.ordermod.flag==='false')
                                    {
                                        alert('No such serial found.....');
                                    }
                                    
                                });
                    };
                  
                    
                    $scope.submit = function () {
                 
                        var formdata = {
                            "seas_code": $('#seas_code').val(),
                            "serial": $('#serial').val(),
                            "buyer_code": $('#buyer_code').val(),
                            "style_no": $('#style_no').val(),
                            "b_style": $('#b_style').val(),
                            "price": $('#price').val(),
                            "quota_seg": $('#quota_seg').val(),
                            "quota_cat": $('#quota_cat').val(),
                            "int_ord": $('#int_ord').val(),
                            "wov_hos": $('#wov_hos').val(),
                            "quota_grp":$('#quota_grp').val(),
                            "main_fab":$('#main_fab').val(),
                            "assort":$('#assort').val(),
                            "order_no": $('#order_no').val(),
                            "order_date": $('#order_date').val(),
                            "delv_date" :$('#delv_date').val(),
                            "agent_comm":$('#agent_comm').val(),
                            "comm_perc":$('#comm_perc').val(),
                            "comp_code":$('#comp_code').val(),
                            "fab_con":$('#fab_con').val(),
                            "garment_desc":$('#gar_desc').val(),
                             "dyed":$('#dyed').val(),
                             "data":$scope.ordermod
                                
                        };

                        var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
                        var response = $http.post('AddOrderModification', formdata, headers);
                        response.success(function (data, status, headers, config) {
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

                }]);
            <%-- $(document).ready(function () {
                 $('#p_type').multiselect();
                 $('#ddlCars1').multiselect({
                     numberDisplayed: 2,
                 });
                 $('#ddlCars2').multiselect({
                     includeSelectAllOption: true,
                     enableFiltering: true

                });
                $('#ddlCars3').multiselect({
                    nonSelectedText: 'Select Cars'

                });
            });--%>

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
                <div class="panel-heading"> Order Modification Form</div>
                <div class="panel-body">
                    <form  class="form-horizontal" name="Orderform" data-ng-submit="submit()" nonvalidate>  
                        <div class="row">
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-2">Select Season</label>
                                    <div data-ng-init="populateSeasList()"  class="col-sm-5" >
                                        <select id="seas_code" ng-model="seas_code"  ng-change="getSeasonDesc()"  class="form-control" >
                                            <option value="" >Select Season</option>
                                            <option data-ng-repeat="s in season" value="{{s.seas_code}}">{{s.seas_code}}</option>
                                        </select>                           
                                    </div>

                                </div>
                            </div>
                            <div class="col-md-2" >
                                <div class="form-group">
                                     <input type="text"  id="seasonbean.seas_desc"  ng-init=" " ng-model="seasonbean.seas_desc" ng-value="data.seas_desc" class="form-control" style="border:0px"/>
                                   
                                </div>
                            </div>
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Serial</label>
                                    <div class="col-sm-4"> 
                                        <input type="number" min="1" id="serial" name="serial"  data-ng-model="serial" ng-blur="getOrderModdata(seas_code, serial)" class="form-control"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Buyer Code</label>
                                    <div class="input-group col-sm-5">
                                        <input class="form-control" id="buyer_code" type="text"  ng-model="buyer_code" ng-value="ordermod.buyer_code">
                                      
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Style No.</label>
                                     <div class="input-group col-sm-5">
                                        <input class="form-control" id="style_no" type="text"  ng-model="style_no" ng-value="ordermod.style_no">
                                      
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6" >
                               <div class="form-group">
                                    <label class="control-label col-sm-1">Price</label>
                                    <div class="col-sm-4"> 
                                        <input type="text" name="price" id="price" ng-model="price" ng-value="ordermod.price" class="form-control" />
                                         <span ng-show="Orderform.price.$touched &&  Orderform.price.$error.required" style="color: red">Required.</span>
                                      
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5" >
                               <div class="form-group">
                                    <label class="control-label col-sm-5">Order Quantity</label>
                                    <div class="col-sm-5"> 
                                        <input type="text"  id="order_qty" ng-model="order_qty" name="order_qty" ng-value="ordermod.order_qty"  class="form-control"/>
                                             <span ng-show="Orderform.order_qty.$touched && Orderform.order_qty.$invalid && Orderform.order_qty.$error.required" style="color: red">Order Qty is required.</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Buyer Style</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="b_style" data-ng-model="b_style" ng-value="ordermod.b_style" class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                   <div class="form-group">
                                    <label class="control-label col-sm-3"> Order Date </label>
                                    <div class="col-sm-4"> 
                                        <input type="date" ng-model="order_date" id="order_date" name="order_date" ng-value="ordermod.order_date" class="form-control" />
                                         <span ng-show="Orderform.order_date.$touched && Orderform.order_date.$invalid && Orderform.order_date.$error.required" style="color: red">Required.</span>
                                    </div>
                                </div>
                            </div>
                        
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Quota Seg.</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="quota_seg" name="quota_seg" ng-model="quota_seg"  ng-value="ordermod.quota_seg"  class="form-control"/>
                                        <span ng-show="Orderform.quota_seg.$touched && Orderform.quota_seg.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Quota Cat.</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="quota_cat" name="quota_cat" ng-model="quota_cat" data-ng-value="ordermod.quota_cat"  class="form-control"/>
                                         <span ng-show="Orderform.quota_cat.$touched  && Orderform.quota_cat.$error.required" style="color: red">Required.</span>
                      </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Garment Description</label>
                                    <div class="col-sm-4"> 
                                        <input type="text"  id="gar_desc" ng-model="gar_desc" data-ng-value="ordermod.gar_desc" class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                               <div class="form-group">
                                    <label class="control-label col-sm-4">Main fabric</label>
                                    <div class="col-sm-4"> 
                                        <input type="text"  id="main_fab" ng-model="main_fab" ng-value="ordermod.main_fab"  class="form-control"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                  
                        <div class="row">
                             <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Wov/Hos/Swe</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="wov_hos" name="wov_hos" ng-model="wov_hos" ng-value="ordermod.wov_hos"  class="form-control"/>
                                        <span ng-show="Orderform.wov_hos.$touched  && Orderform.wov_hos.$error.required" style="color: red">Required.</span>
                                     
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Order No</label>
                                    <div class="col-sm-4"> 
                                        <input type="text"  id="order_no" ng-model="order_no" name="order_no" ng-value="ordermod.order_no"  ng-blur="getOrderno(order_no,seas_code, style_no)" class="form-control"/>
                                             <span ng-show="Orderform.order_no.$touched && Orderform.order_no.$invalid && Orderform.order_no.$error.required" style="color: red">Order no is required.</span>
                                    </div>
                                </div>
                            </div>
                           </div>
                  
                         <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Fabric content</label>
                                    <div class="col-sm-4"> 
                                        <input type="text"  id="fab_con" ng-model="fab_con" ng-value="ordermod.fab_con"  class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Company Code</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="comp_code" ng-model="comp_code" ng-value="ordermod.comp_code"  class="form-control"/>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Dyed Style</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="dyed" name="dyed" ng-model="dyed" ng-value="ordermod.dyed"   class="form-control"/>
                                           <span ng-show="Orderform.dyed.$touched  && Orderform.dyed.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                              <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Agent Commision</label>
                                    <div class="col-sm-2"> 
                                        <input type="text" name="agent_comm" id="agent_comm" ng-model="agent_comm" required ng-value="ordermod.agent_comm"  class="form-control"/>
                                      <span ng-show="Orderform.agent_comm.$touched && Orderform.agent_comm.$invalid && Orderform.agent_comm.$error.required" style="color: red">Required.</span>

                                    </div>
                                    <div class="col-sm-2"> 
                                        <input type="text" name="comm_perc" id="comm_perc" ng-model="comm_perc" required ng-value="ordermod.comm_perc"  class="form-control"/>
                                      <span ng-show="Orderform.agent_comm.$touched && Orderform.agent_comm.$invalid && Orderform.agent_comm.$error.required" style="color: red">Required.</span>

                                    </div>
                                      <div class="col-sm-0"> 
                                          <label class="control-label col-sm-1">%</label>
                                      </div>
                                </div>
                            </div>
                        </div>
                         <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Delivery Date</label>
                                    <div class="col-sm-4"> 
                                        <input type="date"  id="delv_date" name="delv_date" ng-model="delv_date" ng-value="ordermod.delv_date"   class="form-control"/>
                                           <span ng-show="Orderform.dyed.$touched  && Orderform.dyed.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                              <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Assortment NO.</label>
                                    <div class="col-sm-3"> 
                                        <input type="text" name="assort" id="assort" ng-model="assort"  ng-value="ordermod.assort"  class="form-control"/>
                                      

                                    </div>
                                </div>
                            </div>
                        </div>
                          <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Quota Group</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="quota_grp" name="quota_grp" ng-model="quota_grp" ng-value="ordermod.quota_grp"   class="form-control"/>
                                           <span ng-show="Orderform.dyed.$touched  && Orderform.dyed.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                              <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Remake</label>
                                    <div class="col-sm-3"> 
                                        <input type="text" name="int_ord" id="assort" ng-model="int_ord" required ng-value="ordermod.int_ord"  class="form-control"/>
                                      

                                    </div>
                                </div>
                            </div>
                        </div>
                        <input type="submit" value="UPDATE ORDER" class="btn btn-primary"/>

                        <div class="table-responsive">          
                            <table class="table table-bordered">
                                <thead>
                                    <tr><th>COLOUR</th>
                                        <th>COLOUR NAME</th>
                                        <th>CONTENT</th></tr>
                                </thead>
                                <tbody ng-repeat="op in ordermod.colourdata">
                                    <tr >
                                        <td>{{op[0].colour_code}}</td>
                                        <td>{{op[0].colour_desc}}</td>

                                        <td>{{ordermod.fab_con}}</td>
                                       
                                        <td>{{ordermod.fab_con2}}</td>
                                    </tr>

                                </tbody>
                            </table>
                        </div>
                    </form>

                  

                </div>
            </div>

        </div>
        <!-- Modal -->

    </body>
</html>
