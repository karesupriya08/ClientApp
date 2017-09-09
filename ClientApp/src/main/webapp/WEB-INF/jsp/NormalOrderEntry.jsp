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
        <title>Normal Order Entry Form</title>

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

                    $scope.choices = [{}];

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
                            $http.get('http://localhost:8080/ClientApp/getseasondescMaxserial', {params: {seas_code: seas_code}}).
                                    success(function (response) {

                                        $scope.data = response;

                                    });
                        }
                        $http.get('getBuyerCodeList').
                                success(function (response) {
                                    $scope.buyer = response;
                                });

                    };
                    $scope.myFunc = function (serial) {
                        $http.get('getalldata1', {params: {serial: serial}}).
                                success(function (data) {
                                    $scope.orderdata = data;
                                });
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
                    $scope.getOrderdata = function (seas_code, style_no, buyer_code) {
                        $http.get('getOrderdata', {params: {seas_code: seas_code, style_no: style_no, buyer_code: buyer_code}}).
                                success(function (response) {

                                    $scope.normalorder = response;
                                });
                    };

                    var cnt = 1;

                    // $scope.choices=[{}];
                    $scope.addcolour = function (colour) {
                        var cnt = 1;

                        $scope.choices = [{'colour_way': cnt + '-' + colour}];
                        $scope.colqty = colour;

                        $scope.showModal = true;
                    };
                    cnt = 2;
                    $scope.addNewChoice = function () {

                        var colqty = document.getElementById("colour").value;

                        if (cnt <= colqty) {
                            var newItemNo = $scope.choices.length + 1;
                            $scope.choices.push({colour_way: cnt + '-' + colqty});

                            cnt++;
                        }
                    };
                    $scope.removeChoice = function () {
                        var lastItem = $scope.choices.length - 1;
                        $scope.choices.splice(lastItem);
                    };

                    $scope.Add = function () {
                        alert('data saved');
                        cnt = 2;
                        console.log($scope.choices);
                        $scope.showModal = false;
                    };

                    $scope.cancel = function () {
                        cnt = 2;
                        $scope.showModal = false;
                    };
                    $scope.getVal = function () {
                        console.log($scope.choices);
                    };
                    
                    $scope.calulateQty=function(colour_qty)
                    {
                        var totqty=$('#qty').val();
                        $scope.qty= totqty - colour_qty;
                       
                    };

                    $scope.getOrderno = function (order_no,seas_code, style_no)
                    {
                        //alert(order_no);
                        if($('#order_no').val()==='')
                        {
                            order_no="";
                            
                        }
                    
                    
                       $http.get('getOrderno', {params: {order_no: order_no,seas_code:seas_code,style_no:style_no}}).
                                success(function (response)
                                {
                                    $scope.orderno = response;
                                    if($scope.orderno.flag===true)
                                    {
                                        alert("This order_no is already present");
                                    }
                                   
                                });
                    };
                    
                    $scope.submit = function () {
                      <%--  $scope.myform.serial.$setDirty();
                        $scope.myform.serial.$setTouched();
                        $scope.myform.serial.$dirty = true;--%>
                        var formdata = {
                            "seas_code": $('#seas_code').val(),
                            "serial": $('#serial').val(),
                            "buyer_code": $('#buyer_code').val(),
                            "style_no": $('#style_no').val(),
                            "ord_stat": $('#ord_stat').val(),
                            "b_style": $('#b_style').val(),
                            "p_type": $('#p_type').val(),
                            "choices": $scope.choices,
                            "colour": $('#colour').val(),
                            "price": $('#price').val(),
                            "currency": $('#currency').val(),
                            "quota_seg": $('#quota_seg').val(),
                            "quota_cat": $('#quota_cat').val(),
                            "int_ord": $('#int_ord').val(),
                            "wov_hos": $('#wov_hos').val(),
                            "emb_fl": $('#emb_fl').val(),
                            "order_no": $('#order_no').val(),
                            "order_date": $('#order_date').val(),
                          
                            "agent_comm":$('#agent_comm').val(),
                            "comp_code":$('#comp_code').val(),
                            "fab_con":$('#fab_con').val()

                        };

                        var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
                        var response = $http.post('AddOrder', formdata, headers);
                        response.success(function (data, status, headers, config) {
                           $scope.res=data;
                           alert( $scope.res.msg);

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
                <div class="panel-heading">Normal Order Entry Form</div>
                <div class="panel-body">
                    <form  class="form-horizontal" name="Orderform" data-ng-submit="submit()" nonvalidate>  
                        <div class="row">
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-6">Select Season</label>
                                    <div data-ng-init="populateSeasList()"  class="col-sm-5" >
                                        <select id="seas_code" ng-model="seas_code"  ng-change="getSeasonDesc()"  class="form-control" >
                                            <option value="" >Select Season</option>
                                            <option data-ng-repeat="s in season" value="{{s.seas_code}}">{{s.seas_code}}</option>
                                        </select>                           
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <div class="col-sm-6"> 
                                        <input type="text"  id="seasonbean.seas_desc"  ng-init=" " ng-model="seasonbean.seas_desc" ng-value="data.seas_desc" class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Control #</label>
                                    <div class="col-sm-4"> 
                                        <input type="text"  id="serial" name="serial"  data-ng-model="serial"  ng-value="data.maxSerial" class="form-control"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Buyer Code</label>
                                    <div class="input-group col-sm-5">
                                        <input class="form-control" id="buyer_code" type="text" maxlength="4" ng-keyup="(buyer_code.length >= 4) && getStyleNo(seas_code, buyer_code)" placeholder="Enter New Buyer Code" ng-model="buyer_code" ng-value="b.buyer_code">
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
                                        <select id="style_no" data-ng-model="style_no"   class="form-control" ng-change="getOrderdata(seas_code, style_no, buyer_code)">
                                            <option value="" >Select Style</option>
                                            <option data-ng-repeat="st in style" value="{{st.style_no}}">{{st.style_no}}</option>
                                        </select>                           
                                    </div>  
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Order Status</label>
                                    <div class="col-sm-6"> 
                                        <input type="text"  id="ord_stat" name="ord_stat" data-ng-model="ord_stat"  ng-value="normalorder.ord_stat" class="form-control" />
                                         <p ng-show="Orderform.ord_stat.$invalid && !Orderform.ord_stat.$pristine" class="help-block with-errors">Order Status is required.</p>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5"> Order Date </label>
                                    <div class="col-sm-6"> 
                                        <input type="date" ng-model="order_date" id="order_date" name="order_date" class="form-control" required/>
                                         <span ng-show="Orderform.order_date.$touched && Orderform.order_date.$invalid && Orderform.order_date.$error.required" style="color: red">Required.</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-3" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Buyer Style</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="b_style" data-ng-model="b_style" ng-value="normalorder.b_style" class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Price</label>
                                    <div class="col-sm-4"> 
                                        <input type="text" name="price" id="price" ng-model="price" ng-value="normalorder.price" class="form-control" />
                                         <span ng-show="Orderform.price.$touched &&  Orderform.price.$error.required" style="color: red">Required.</span>
                                      
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-1" >
                                <div class="form-group">
                                    <div class="col-sm-3">
                                        <select id="p_type" ng-model="p_type"  ng-value="normalorder.p_type" class="form-control">
                                            <option value="F">FOB</option>
                                            <option value="C">C&F</option>
                                            <option value="O">OTHERS</option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Currency</label>
                                    <div class="col-sm-3"> 
                                        <select id="currency" name="currency" ng-model="currency"  ng-value="normalorder.currency"  required class="form-control" >
                                            <option value="EUR" >EUR</option>
                                            <option value="INR" >INR</option>
                                            <option value="USD" >USD</option>
                                            <option value="GBP" >GBP</option>

                                        </select>   
                                         <span ng-show="Orderform.currency.$touched  && Orderform.currency.$error.required" style="color: red">Required.</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Quota Seg.</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="quota_seg" name="quota_seg" ng-model="quota_seg"  ng-value="normalorder.quota_seg"  class="form-control"/>
                                        <span ng-show="Orderform.quota_seg.$touched && Orderform.quota_seg.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Quota Cat.</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="quota_cat" name="quota_cat" ng-model="quota_cat" data-ng-value="normalorder.quota_cat"  class="form-control"/>
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
                                        <input type="text"  id="gar_desc" ng-model="gar_desc" data-ng-value="normalorder.gar_desc" class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Internal Order</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="int_ord" name="int_ord" ng-model="int_ord"  data-ng-value="normalorder.int_ord" class="form-control"/>
                                             <span ng-show="Orderform.int_ord.$touched  && Orderform.int_ord.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Colours</label>
                                    <div class="col-sm-3"> 
                                        <input type="number" name="colour" id="colour" ng-model="colour" required class="form-control"/>
                                        <span ng-show="Orderform.colour.$touched && Orderform.colour.$invalid && Orderform.colour.$error.required" style="color: red">Colour is required.</span>
                                    </div>

                                </div>

                            </div>
                            <div class="col-md-2" >
                                <div class="form-group">
                                    <button type="button" class="btn btn-primary" ng-click="addcolour(colour)" data-ng-disabled="Orderform.colour.$error.required">Add Colours</button>
                                </div>
                            </div>

                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Wov/Hos/Swe</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="wov_hos" name="wov_hos" ng-model="wov_hos" ng-value="normalorder.wov_hos"  class="form-control"/>
                                        <span ng-show="Orderform.wov_hos.$touched  && Orderform.wov_hos.$error.required" style="color: red">Required.</span>
                                     
                                    </div>
                                </div>
                            </div></div>
                        <div class="row">
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Embroidery Style</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="emb_fl" name="emb_fl" ng-model="emb_fl" ng-value="normalorder.emb_fl"   class="form-control"/>
                                      <span ng-show="Orderform.emb_fl.$error.required" style="color: red">Required.</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Order No</label>
                                    <div class="col-sm-5"> 
                                        <input type="text"  id="order_no" ng-model="order_no" name="order_no" ng-value="orderno.order_no"  ng-blur="getOrderno(order_no,seas_code, style_no)" class="form-control"/>
                                             <span ng-show="Orderform.order_no.$touched && Orderform.order_no.$invalid && Orderform.order_no.$error.required" style="color: red">Order no is required.</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Order Quantity</label>
                                    <div class="col-sm-5"> 
                                        <input type="text"  id="order_qty" ng-model="order_qty" name="order_qty" required class="form-control"/>
                                             <span ng-show="Orderform.order_qty.$touched && Orderform.order_qty.$invalid && Orderform.order_qty.$error.required" style="color: red">Order Qty is required.</span>
                                    </div>
                                </div>
                            </div></div>
                        <div class="row">
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Main fabric</label>
                                    <div class="col-sm-4"> 
                                        <input type="text"  id="main_fab" ng-model="main_fab" ng-value="normalorder.main_fab"  class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Print</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="print" ng-model="print" ng-value="normalorder.print"  class="form-control"/>

                                    </div>
                                </div>
                            </div>
                        </div>
                         <div class="row">
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Fabric content</label>
                                    <div class="col-sm-4"> 
                                        <input type="text"  id="fab_con" ng-model="fab_con" ng-value="normalorder.fab_con"  class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Company Code</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="comp_code" ng-model="comp_code" ng-value="normalorder.comp_code"  class="form-control"/>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-4">Dyed Style</label>
                                    <div class="col-sm-3"> 
                                        <input type="text"  id="dyed" name="dyed" ng-model="dyed" ng-value="normalorder.dyed" required  class="form-control"/>
                                           <span ng-show="Orderform.dyed.$touched  && Orderform.dyed.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                              <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Agent Commision</label>
                                    <div class="col-sm-3"> 
                                        <input type="text" name="agent_comm" id="agent_comm" ng-model="agent_comm" required ng-value="normalorder.agent_comm" required class="form-control"/>
                                      <span ng-show="Orderform.agent_comm.$touched && Orderform.agent_comm.$invalid && Orderform.agent_comm.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <input type="submit" value="ADD ORDER" ng-disabled="Orderform.$invalid" class="btn btn-primary"/>

                        <div class="table-responsive">          
                            <table class="table table-bordered">
                                <thead>
                                    <tr><th>COLOUR</th>
                                        <th>COLOUR NAME</th>
                                        <th>CONTENT</th></tr>
                                </thead>
                                <tbody ng-repeat="op in normalorder.colourdata">
                                    <tr >
                                        <td>{{op[0].colour_code}}</td>
                                        <td>{{op[0].colour_desc}}</td>

                                        <td>{{normalorder.fab_con}}</td>
                                      
                                        <td>{{normalorder.fab_con2}}</td>
                                    </tr>
                                </tbody>
                            </table>
                        </div>
                    </form>

                    <div modal="showModal" close="cancel()">
                        <div class="modal-header">

                            <h4 class="modal-title">Add Colours</h4>
                        </div>
                        <div class="modal-body">
                            <fieldset  data-ng-repeat="choice in choices">
                                <div class="row">
                                    <div class="col-sm-2"> 
                                        <input type="text" ng-model="choice.colour_code" name="" placeholder="Enter colour code" class="form-control"></div>
                                    <div class="col-sm-3"> 
                                        <select ng-model="choice.colour_code" class="form-control">
                                            <option value="" >Select Colour</option>
                                            <option data-ng-repeat="color in normalorder.colourlist" value="{{color.colour_code}}">{{color.colour_code}}  {{color.colour_desc}}</option>
                                        </select>
                                    </div>
                                    <div class="col-sm-1"> 
                                        <input type="text" ng-model="choice.colour_way"  name="" class="form-control"> </div>
                                    <div class="col-sm-2">   <input type="text" ng-model="choice.colour_qty" name="" ng-blur="calulateQty(choice.colour_qty)" class="form-control" placeholder="Quantity"></div>
                                    <div class="col-sm-3">   <input type="date" ng-model="choice.delv_date" name=""  class="form-control"></div>

                                    <div class="col-sm-1">    <button class="remove" ng-show="$last" ng-click="removeChoice()" button tiny radius>-</button></div>
                                </div>
                            </fieldset>
                                 <div class="col-sm-1">   <input type="text" ng-model="qty" id="qty" name="qty" ng-value="order_qty" class="form-control"></div>
                            <button class="addfields" ng-click="addNewChoice()">Add fields</button>

                            <div id="choicesDisplay">
                                {{ choices}}
                            </div>

                        </div>
                        <div class="modal-footer">
                            <button class="btn btn-success" ng-click="Add()">Add</button>
                            <button class="btn" ng-click="cancel()">Cancel</button>
                        </div>
                    </div>
                    {{choices}}

                </div>
            </div>

        </div>
        <!-- Modal -->

    </body>
</html>
