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
        <title>OGRS Printing</title>

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
            myApp.controller("myCtrl", ['$scope', '$http', function ($scope, $http, $modal)
                {

                    $scope.formdata = {};
                    $scope.isDisabled = true;
                     $('#printdiv').hide();
                    $scope.print = function ()
                    {
                         $('#printdiv').show();
                          window.print();
                              $('#printdiv').hide();
                          window.onfocus=function(){ 
                              window.close();
                              $('#printdiv').hide();
                          };
                       
                    };
                    $scope.getSizeQtyData=function(seas_code, serial, colour_code)
                    {
                         $http.get('printOGRS', {params: {seas_code: seas_code, serial: serial, colour_code: colour_code}}).
                                success(function (response) {
                                    console.log(response);
                                    $scope.sizeqtydata = response;
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

                                        $scope.data = response;

                                    });
                        }
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
                    var total = 0;


                    $scope.submit = function () {

                        alert('submit form');
                        var formdata = {
                            "seas_code": $('#seas_code').val(),
                            "serial": $('#serial').val(),
                            "buyer_code": $('#buyer_code').val(),
                            "style_no": $('#style_no').val(),
                            "b_style": $('#b_style').val(),
                            "colour": $('#colour_code').val(),
                            "choices": $scope.choices

                        };

                        var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
                        var response = $http.post('printOGRS', formdata, headers);
                        response.success(function (data, status, headers, config) {
                            $scope.result = data;

                            alert($scope.result.msg);
                            console.log('status', status);
                            console.log('data', status);
                            console.log('headers', status);

                        });
                        response.error(function (data, status, headers, config) {
                            $scope.result = data;
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
            @media print
            {
                .noprint {display:none;}
            }
            .table{
                margin-bottom: 6px;
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
                <div class="collapse navbar-collapse" id="myNavbar" noprint>
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
            <div class="panel panel-info noprint" style='width:70%;margin-left: 10%' >
                <div class="panel-heading">OGRS Printing</div>
                <div class="panel-body">
                    <form  class="form-horizontal" name="myform"  nonvalidate>  
                        <div class="row">
                            <div class="col-md-6" >
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
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <input type="text"  id="seasonbean.seas_desc"  ng-init=" " readonly ng-model="seasonbean.seas_desc" ng-value="data.seas_desc" class="form-control" style="border:0px"/>

                                </div>
                            </div>
                          
                        </div>
                        <div class="row">
                              <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Serial</label>
                                    <div class="col-sm-4"> 
                                        <input type="number" min="1" id="serial" name="serial"  data-ng-model="serial" required ng-blur="getColours(seas_code, serial)" class="form-control"/>
                                        <span ng-show="myform.serial.$touched && myform.serial.$error.required" style="color: red">Required.</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-sm-6"> 
                                <div class="form-group">
                                    <label class="control-label col-sm-3">Select Colour</label>
                                    <div class="col-sm-5"> 
                                        <select ng-model="colour_code" id="colour_code" name="colour_code" required class="form-control" ng-blur="getSizeQtyData(seas_code, serial, colour_code)">
                                            <option value="" >Select Colour</option>
                                            <option data-ng-repeat="color in colours.colourList" value="{{color.colour_code}}">{{color.colour_code}}  {{color.colour_desc}}</option>
                                        </select>
                                        <span ng-show="myform.colour_code.$touched && myform.colour_code.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <button ng-click="print()" >print</button>
                </div>
 
                </form>
            </div>
        </div>

        <div id="printdiv">
            <div>  <span><b>R.M.X. J O S S  ORDERED GARMENT REQUIREMENT SHEET </b></span> <span style="margin-left: 100px">DATE: - {{sizeqtydata.current_date}} <span style="margin-left: 30px">{{sizeqtydata.time}}</span></span> </div>
            <table class="table table-bordered table-condensed  table-sm " style="width:80;font-size: 10px;line-height:10px;padding: 0px">
                <tr><td class="col-lg-8">

                        <table class="table table-striped" ><b>
                            <tr><td> Buyer_style :</td><td> {{sizeqtydata.b_style}}</td> </tr>
                            <tr><td> Buyer :</td><td><span >{{sizeqtydata.buyer_code}}</span> <span style="margin-left: 50px"> {{sizeqtydata.buyer_name}}</span></td></tr>
                            <tr><td> Control # :</td><td>{{sizeqtydata.seas_code}} / {{sizeqtydata.serial}}/ {{sizeqtydata.colour_way}} / {{sizeqtydata.ord_stat}} / {{sizeqtydata.colour}} / {{sizeqtydata.colour_desc}} </td></tr>
                            <tr><td>PAT.REF # :</td><td>STYLE # :{{sizeqtydata.style_no}}</td></tr>
                            <tr><td>ORDER QTY</td><td>{{sizeqtydata.order_qty}} PCS</td></tr></b>
                            <tr><td>Garment Desc </td><td>{{sizeqtydata.gar_desc}}</td></tr>
                            <tr><td>Main Fab </td><td>{{sizeqtydata.main_fab}}</td></tr>
                            <tr><td>Print </td><td>{{sizeqtydata.print}}</td></tr>
                        </table>
                        SIZE BREAKUP
                        <table class="table table-striped table-bordered table-condensed table-hover table-sm" >
                            <tr><td class="col-sm-1">Sizes</td><td ng-repeat="s in sizeqtydata.size">{{s.SIZE_TYPE}}</td><td class="col-sm-1"></td><td></td><td></td></tr>
                            <tr><td class="col-sm-1">QTY</td><td ng-repeat="s in sizeqtydata.size">{{s.SIZE_QTY}}</td><td class="col-sm-1"> </td><td></td><td></td></tr>
                        </table>
                    </td>
                    <td class="col-lg-4" style="width:30%">
                        <p>SKETCH</p>
                    </td>

                </tr>

            </table>
            <P> FABRIC REQUIREMENTS</P>
            <TABLE class="table table-striped table-bordered  " >
                <thead style="text-align: center">
                <th class="col-sm-3">FABRIC   </th>
                <th class="col-sm-3">LIVE DESCRIPTION</th>
                <th class="col-sm-3">GREY DESCRIPTION</th>
                <th class="col-sm-1">COLOUR</th>
                <th class="col-sm-1">WIDTH</th>
                <th class="col-sm-1">CONS</th>
                <th class="col-sm-1">UOM</th>
                </thead>
                <tbody >
                    <tr ng-repeat="i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11]">
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                        <td></td>
                    </tr>
                </tbody>
            </TABLE>
           
<table  style="font-size: 10px;line-height:10px;padding: 0px;width:100%">
                <tr><td class="col-lg-8" style="width:70%">

                       <table class="table table-bordered"  >
                            <thead style="text-align: center">
                            <th class="col-sm-3">BUTTONS/ZIPS/LACES/INTERLINING</th>
                            <th class="col-sm-1" >COLOUR</th>
                            <th class="col-sm-1">SIZE/HOLES</th>
                            <th class="col-sm-1">CONS</th>
                            <th class="col-sm-1">UOM</th>
                            </thead>
                            <tbody>
                                <tr ng-repeat="i in [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]">
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                    <td></td>
                                </tr>
                                <tr><td colspan="5" style="text-align: center">SPECIAL INSTRUCTIONS </td></tr>
                                 <tr><td colspan="5"> </td></tr>
                                  <tr><td colspan="5"> </td></tr>
                                    <tr><td colspan="5"> </td></tr>
                                  
                            </tbody>
                        </table>  
                       
                    </td>
                    <td class="col-lg-4" style="width:40%">
                      <table class="table table-bordered" style="table-layout:fixed;" >
                            <tr> <td >FABRICATION</td><td class="col-sm-2"></td></tr>
                            <tr> <td >HAND EMB.</td><td class="col-sm-2"></td></tr>
                            <tr> <td>MACH. EMB.</td><td class="col-sm-2"></td></tr>
                            <tr> <td >OTHER EMB.</td><td class="col-sm-2"></td></tr>
                            <tr> <td >DYEING RATE</td><td class="col-sm-2"></td></tr>
                            <tr><td colspan="2"  style="text-align: center;height: 120px">LABEL</td></tr>
                        </table>  
                    </td>
                </tr>
            </table>
            <div style="margin-top:20px">
            <span style="margin-left: 30px;width: 20px">Prepared By :</span>
            <span style="margin-left: 180px;">Checked By :</span> 
            <span style="margin-left: 180px;">Authorised By :</span> 
            </div>
        </div>





    </body>
</html>

 