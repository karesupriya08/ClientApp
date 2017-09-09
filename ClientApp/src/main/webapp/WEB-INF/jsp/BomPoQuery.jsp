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
        <title>BOM/PO Entry Form</title>

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
                    $('#printdiv').hide();
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
                    $scope.getBuyerCode = function (seas_code)
                    {
                        $http.get('getBuyerCode', {params: {seas_code: seas_code}}).
                                success(function (response)
                                {
                                    $scope.buyercode = response;
                                    console.log(response);
                                });
                    };
                    $scope.getStyleNo = function (seas_code)
                    {
                        var mode = $('#mode').val();
                        var bcode = $('#buyer_code').val();

                        $http.get('getStyleNo', {params: {seas_code: seas_code, buyer_code: bcode, mode: mode}}).
                                success(function (response)
                                {
                                    $scope.stylenolist = response;
                                    console.log(response);
                                });
                    };
                    $scope.getControlData = function (seas_code, style_no)
                    {

                        var mode = $('#mode').val();
                        var bcode = $('#buyer_code').val();
                        $http.get('getControlData', {params: {seas_code: seas_code, buyer_code: bcode, mode: mode, style_no: style_no}}).
                                success(function (response)
                                {
                                    $scope.controldata = response;
                                    console.log(response);
                                });
                    };
                    $scope.getsizeBomdata = function (serial, colour, ord_stat, colour_desc)
                    {
                        var seas_code = $scope.seas_code;
                        var buyer_code = $scope.buyer_code;
                        var mode = $('#mode').val();
                        $scope.serial = serial;
                        $scope.colour = colour;
                        $scope.o_stat = ord_stat;
                        $scope.col_desc = colour_desc;

                        $http.get('getsizeBomdata', {params: {seas_code: seas_code, serial: serial, colour: colour, mode: mode, buyer_code: buyer_code}}).
                                success(function (response)
                                {
                                    $scope.sizeBomdata = response;
                                    $scope.itemcode = $scope.sizeBomdata.itemcode;
                                });
                    };
                    $scope.getBomtable = function ()
                    {
                        $('#tablebom').show();
                        $('#tablefab').hide();
                    };
                    $scope.getFabRate = function ()
                    {
                        var serial = $scope.serial;
                        var colour = $scope.colour;
                        var seas_code = $scope.seas_code;
                        var buyer_code = $scope.buyer_code.BUYER_CODE;
                        var style_no = $scope.style_no;
                        var mode = $('#mode').val();

                        $('#tablebom').hide();
                        $http.get('getFabRate', {params: {seas_code: seas_code, serial: serial, colour: colour, mode: mode, buyer_code: buyer_code, style_no: style_no}}).
                                success(function (response)
                                {
                                    $scope.fabdata = response;
                                    $('#tablefab').show();
                                });
                    };
                    $scope.getIssueDetail = function ()
                    {
                        var serial = $scope.serial;
                        var colour = $scope.colour;
                        var seas_code = $scope.seas_code;
                        var buyer_code = $scope.buyer_code.BUYER_CODE;
                        var style_no = $scope.style_no;
                        var mode = $('#mode').val();
                        var itemcode = $scope.sizeBomdata.itemcode;
                        $http.get('getIssueDetail', {params: {seas_code: seas_code, serial: serial, colour: colour, mode: mode, buyer_code: buyer_code, style_no: style_no, itemcode: itemcode}}).
                                success(function (response)
                                {
                                    $scope.issuedetail = response;

                                });
                    };
                    $scope.getFOC = function ()
                    {
                        var serial = $scope.serial;
                        var colour = $scope.colour;
                        var seas_code = $scope.seas_code;
                        var buyer_code = $scope.buyer_code.BUYER_CODE;
                        var style_no = $scope.style_no;
                        var mode = $('#mode').val();
                        var itemcode = $scope.sizeBomdata.itemcode;
                        $http.get('getFOC', {params: {seas_code: seas_code, serial: serial, colour: colour, mode: mode, buyer_code: buyer_code, style_no: style_no, itemcode: itemcode}}).
                                success(function (response)
                                {
                                    $scope.foc = response;

                                });
                    };
                    $scope.getImport = function ()
                    {
                        var serial = $scope.serial;
                        var colour = $scope.colour;
                        var seas_code = $scope.seas_code;
                        var buyer_code = $scope.buyer_code.BUYER_CODE;
                        var style_no = $scope.style_no;
                        var mode = $('#mode').val();
                        var itemcode = $scope.sizeBomdata.itemcode;
                        $http.get('getImport', {params: {seas_code: seas_code, serial: serial, colour: colour, mode: mode, buyer_code: buyer_code, style_no: style_no, itemcode: itemcode}}).
                                success(function (response)
                                {
                                    $scope.import = response;
                                    if ($scope.import.flag === 'false')
                                    {
                                        alert($scope.import.msg);
                                    }

                                });
                    };

                    $scope.print = function ()
                    {
                          $('#printdiv').show();
                          window.print();
                              $('#printdiv').hide();
                          window.onfocus=function(){ 
                              window.close();
                              $('#printdiv').hide();
                          };
                     <%--   var bomdt =
                                {
                                    'bomdata': $scope.sizeBomdata.bomdata,
                                    'stylenolist': $scope.sizeBomdata.stylenolist,
                                    'b_style': $scope.sizeBomdata.b_style,
                                    'order_qty': $scope.sizeBomdata.order_qty
                                };--%>

                       

                    };
                    $scope.reset = function ()
                    {
                        $scope.season = "";
                        $scope.seasondesc = "";

                        $scope.buyer_code = "";
                        $scope.b_style = "";

                        $scope.style_no = "";
                        $scope.controldata = "";
                        $scope.sizeBomdata = "";
                        $scope.fabdata = "";
                          $('#printdiv').hide();
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
                        var total = 0;
                        angular.forEach($scope.choices, function (value, key) {
                            console.log(key + ': ' + value.size_qty);
                            total = total + value.size_qty;
                            console.log(total);
                        });
                        var qty = $('#order_qty').val();
                        console.log(total + "         " + qty);
                        if (qty != total)
                        {
                            alert("Size Quantity doesnt match with order quantity..");
                        }
                        else
                        {
                            var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
                            var response = $http.post('saveSizeQtyPOData', formdata, headers);
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
                        }

                    };


                }]);


        </script>

        <style>
            #heading {
                background: #D9A9D0;
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
            .table-responsive {
                max-height:300px;
            }
            #someid tr td:nth-child(2){
                width:40%;
            }
            @media print
            {
                .noprint {display:none;}
            }
            p
            {
                padding: 0px;
                margin:0px;
            }


        </style>
    </head>
    <body  data-ng-controller="myCtrl">
        <nav class="navbar navbar-inverse">
            <div class="container-fluid noprint">
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
        <div class="noprint">
            <div class="panel panel-info" style='width:85%;margin-left: 8%'>
                <div class="panel-heading">BOM/PO Query Form</div>
                <div class="panel-body">
                    <form  class="form-horizontal" name="myform" nonvalidate >  
                        <div class="row">
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-2">Select Season</label>
                                    <div data-ng-init="populateSeasList()"  class="col-sm-5" >
                                        <select id="seas_code" ng-model="seas_code" name="seas_code" required ng-change="getSeasonDesc()" ng-blur="getBuyerCode(seas_code)" class="form-control" >
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
                            <div class="col-md-2" ></div>
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-2">Order Quantity</label>
                                    <div class="input-group col-sm-2">
                                        <input type="text"  id="order_qty"  readonly ng-model="order_qty" ng-value="sizeBomdata.order_qty" class="form-control" style="border:0px"/>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-2">Buyer Code</label>
                                    <div class="input-group col-sm-4">
                                        <!--   <select ng-model="buyer_code" name="buyer_code" id="buyer_code" class="form-control"  >
                                                    <option value="" >Select Buyer</option>
                                                    <option  ng-repeat="b in buyercode" value="{{b.BUYER_CODE}}">{{b.BUYER_CODE}}</option>
                                              </select>-->
                                        <select ng-model="buyer_code" name="buyer_code" id="buyer_code" class="form-control"
                                                ng-options="s.BUYER_CODE for s in buyercode track by s.BUYER_CODE" ng-blur="getStyleNo(seas_code, mode)">  </select>
                                        <span ng-show="myform.buyer_code.$touched && myform.buyer_code.$error.required" style="color: red">Required.</span>

                                    </div>
                                    {{buyer_code.BUYER_NAME}}
                                </div>
                            </div>
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <div class="input-group form-group-sm col-sm-8">
                                        <fieldset>
                                            <label class="radio-inline"> <input type="radio" id="mode" name="mode" ng-model="mode" value="P"  />Production</label>
                                            <span ng-show="myform.mode.$touched && myform.mode.$error.required" style="color: red">Required.</span>

                                            <label class="radio-inline"> <input type="radio" id="mode" name="mode" ng-model="mode" value="S" />Sampling</label>
                                        </fieldset>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2" ></div>
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-2">Buyer Style</label>
                                    <div class="input-group col-sm-2">
                                        <input type="text"  id="b_style" name="b_style" readonly ng-model="b_style" ng-value="sizeBomdata.b_style" class="form-control" style="border:0px"/>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Style No.</label>
                                    <div class="input-group col-sm-5">
                                        <select ng-model="style_no" name="style_no" id="style_no" class="form-control" ng-blur="getControlData(seas_code, style_no)">
                                            <option >Select Style_No</option>
                                            <option ng-repeat="style in stylenolist" value="{{style.style_no}}">{{style.style_no}}</option>
                                        </select>
                                        <span ng-show="myform.style_no.$touched && myform.style_no.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">

                            <div class="col-md-6" >
                                <div class="form-group">
                                    <div class="table-responsive">          
                                        <table class="table table-bordered table-hover table-condensed table-striped">
                                            <thead >
                                                <tr style="background: lightblue"> <th>Serial</th>
                                                    <th>Order Status</th>
                                                    <th>Colour</th>
                                                    <th>Colour Desc</th>
                                                    <th>Buyer Colour</th>
                                                </tr>
                                            </thead>
                                            <tbody ng-repeat="cdata in controldata">
                                                <tr  class="success" ng-click="getsizeBomdata(cdata.SERIAL, cdata.COLOUR, cdata.ORD_STAT, cdata.COLOUR_DESC)">
                                                    <td >{{cdata.SERIAL}} </td>
                                                    <td>{{cdata.ORD_STAT}} </td>
                                                    <td>{{cdata.COLOUR}} </td>
                                                    <td>{{cdata.COLOUR_DESC}} </td>
                                                    <td>{{cdata.BUYCOL}} </td>
                                                    <td>{{cdata.BUYDESC}}</td></a><tr>
                                            </tbody>
                                        </table> 
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-1" ></div>
                            <div class="col-md-3" >
                                <div class="form-group">
                                    <div class="table-responsive">          
                                        <table class="table table-striped table-bordered table-condensed table-sm">
                                            <thead class="thead-inverse">
                                                <tr style="background: lightblue"> <th col-sm-1>Size Type</th>
                                                    <th col-sm-1>Size Quantity</th>
                                                </tr>
                                            </thead>
                                            <tbody ng-repeat="size in sizeBomdata.stylenolist"  >
                                                <tr class="danger">
                                                    <td>{{size.SIZE_TYPE}}</td>
                                                    <td>{{size.SIZE_QTY}}</td>
                                                </tr>
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-10" ></div>
                            <div class="col-md-2" >
                                <div class="btn-group">
                                    <button type="button" class="btn btn-info">Action</button>
                                    <button type="button" data-toggle="dropdown" class="btn btn-info dropdown-toggle"><span class="caret"></span></button>
                                    <ul class="dropdown-menu">
                                        <li><a ng-click="getFabRate()" href="#">Fab Rate</a></li>
                                        <li><a ng-click="getBomtable()" href="#">Bom Data</a></li>
                                        <li><a ng-click="getIssueDetail()" href="#">Issue Detail</a></li>
                                        <li class="divider"></li>
                                        <li><a ng-click="getImport()" href="#">Import</a></li>
                                        <li><a ng-click="getFOC()" href="#">FOC</a></li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12" >
                                <div class="table-responsive">          
                                    <table class="table table-striped table-bordered table-condensed table-hover table-sm " id="tablebom" >
                                        <thead >
                                            <tr style="background: lightblue"><th class="col-lg-3" ng-repeat="head in sizeBomdata.headings">
                                                    {{head}} </th></tr></thead>

                                        <tbody ng-repeat="bom in sizeBomdata.bomdata" style="font-size: 11px">
                                            <tr class="info">
                                                <td>{{bom.item_code}}</td>
                                                <td>{{bom.item_desc}}</td>
                                                <td>{{bom.colour}}</td>
                                                <td>{{bom.size}}</td>
                                                <td>{{bom.catalog}}</td>
                                                <td>{{bom.aveg}}</td>
                                                <td>{{bom.uom}}</td>
                                                <td>{{bom.part}}</td>
                                                <td>{{bom.status}}</td>
                                                <td>{{bom.qty}}</td>
                                                <td>{{bom.grey_code}}</td>
                                                <td>{{bom.grey_desc}}</td>
                                                <td>{{bom.base_code}}</td>
                                                <td>{{bom.base_desc}}</td>
                                                <td>{{bom.bcolour_desc}}</td>
                                                <td>{{bom.bom_date}}</td>
                                                <td>{{bom.bom_time}}</td>
                                                <td>{{bom.memo_date}}</td>
                                                <td>{{bom.memo_no}}</td>
                                                <td>{{bom.appr_date}}</td>
                                                <td>{{bom.appr_time}}</td>
                                                <td>{{bom.pono}}</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-12" >
                                <div class="table-responsive">          
                                    <table class="table table-striped table-bordered table-condensed table-hover table-sm" id="tablefab" >
                                        <thead >
                                            <tr style="background: lightblue"><th class="col-lg-3" ng-repeat="head in fabdata.headings">
                                                    {{head}} </th></tr></thead>

                                        <tbody ng-repeat="fab in fabdata.fabdata" style="font-size: 11px">
                                            <tr class="info">
                                                <td>{{fab.buyer_code}}</td>
                                                <td>{{fab.style_no}}</td>
                                                <td>{{fab.serial}}</td>
                                                <td>{{fab.colour_desc}}</td>
                                                <td>{{fab.FAB_RATE}}</td>
                                                <td>{{fab.hd_RATE}}</td>
                                                <td>{{fab.MC_RATE}}</td>
                                                <td>{{fab.AR_RATE}}</td>
                                                <td>{{fab.oth6}}</td>
                                                <td>{{fab.oth6_desc}}</td>
                                                <td>{{fab.Others}}</td>
                                                <td>{{fab.oth1}}</td>
                                                <td>{{fab.oth1_desc}}</td>
                                                <td>{{fab.oth2}}</td>
                                                <td>{{fab.oth2_desc}}</td>
                                                <td>{{fab.oth2_desc}}</td>
                                                <td>{{fab.oth3}}</td>
                                                <td>{{fab.oth3_desc}}</td>  
                                                <td>{{fab.oth4}}</td>
                                                <td>{{fab.oth4_desc}}</td>
                                                <td>{{fab.oth5}}</td>
                                                <td>{{fab.oth5_desc}}</td>
                                                <td>{{fab.comp_code}}</td>
                                            </tr>
                                        </tbody>
                                    </table>

                                </div>
                            </div>
                        </div>
                        <button ng-click="reset()"  class="btn btn-primary">Reset</button>
                        <button ng-click="print()"  class="btn btn-primary">Print</button>
                        
                    </form>


                </div>
            </div>

        </div>
        <div style="font-size: 10px" id="printdiv">     
            <p style="width: 100%;font-size: 12px;text-align: center"><b> BOM / Po Details</b></p>
            <table>
                <tr>
                    <td><b>Season :</b></td><td>{{seas_code}}</td>
                </tr>
                <tr>
                    <td><b>Buyer Name :</b></td><td>{{buyer_code.BUYER_CODE}} </td> <td></td>   <td> {{buyer_code.BUYER_NAME}}</td>
                </tr>
                <tr>
                     <td><b>Style No. :</b></td><td> {{style_no}}</td>
                </tr>
                <tr>
                    <td> <b>Control# / Ord-Stat / Colour / Colour Desc :</b></td><td></td><td>{{serial}}  /  {{colour}}  /  {{o_stat}}  /  {{col_desc}}</td>
                </tr>
                
            </table>
         
            <p><b>Size Ratio Detail</b></p>
            <table  style="width: 30%;font-size: 10px;padding: 0px;line-height:10px;border: 1px;border-color: grey ">
                    <thead >
                        <tr > <th col-sm-1>Size Type</th>
                            <th col-sm-1>Size Quantity</th>
                        </tr>
                    </thead>
                    <tbody ng-repeat="size in sizeBomdata.stylenolist"  >
                        <tr>
                            <td>{{size.SIZE_TYPE}}</td>
                            <td>{{size.SIZE_QTY}}</td>
                        </tr>
                    </tbody>
                </table>
          
            
            <p><b>BOM Details</b></p>
           
                <table class="table table-bordered table-condensed  table-sm "  style="width:60;font-size: 9px;line-height:10px;padding: 0px">
                    <thead >
                        <tr>
                            <th class="col-sm-1" >Item Code</th>
                            <th class="col-sm-2" >Item Desc</th>
                            <th class="col-sm-1" >Colour</th>
                             <th class="col-sm-1" >Base Code</th>
                            <th class="col-sm-2" >Base Desc</th>
                            <th class="col-sm-1" >Size</th>
                            <th class="col-sm-1" >Catalog</th>
                            <th class="col-sm-1" >Average</th>
                            <th class="col-sm-1" >UOM</th>
                        </tr>
                    </thead>
                    <tbody ng-repeat="bom in sizeBomdata.bomdata" >
                        <tr >
                            <td>{{bom.item_code}}</td>
                            <td>{{bom.item_desc}}</td>
                            <td>{{bom.colour}}</td>
                            <td>{{bom.base_code}}</td>
                            <td>{{bom.base_desc}}</td>
                            <td>{{bom.size}}</td>
                            <td>{{bom.catalog}}</td>
                            <td>{{bom.aveg}}</td>
                            <td>{{bom.uom}}</td>

                        </tr>
                    </tbody>
                </table>
            
        </div>
    </body>
</html>
