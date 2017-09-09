<%-- 
    Document   : FabRateEntry
    Created on : Jul 5, 2017, 11:44:46 AM
    Author     : Supriya Kare
--%>



<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html data-ng-app="myApp" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Fab Rate/Emb Rate Entry</title>

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
                    $scope.isDisabled = false;
                    $scope.forallDisable = false;
                    $('#otherdetails').hide();
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
                    $scope.getSerial = function (seas_code, style_no)
                    {
                    var buyer_code = $scope.buyer_code.BUYER_CODE;
                            $http.get('getSerial', {params: {seas_code: seas_code, buyer_code: buyer_code, style_no: style_no}}).
                            success(function (response)
                            {
                            $scope.seriallist = response;
                                    console.log(response);
                            });
                    };
                    $scope.getColour = function (seas_code, style_no, serial)
                    {
                    var buyer_code = $scope.buyer_code.BUYER_CODE;
                            $http.get('getColour', {params: {seas_code: seas_code, buyer_code: buyer_code, style_no: style_no, serial: serial}}).
                            success(function (response)
                            {
                            $scope.colourlist = response;
                                    console.log(response);
                            });
                    };
                    $scope.getallcontrol = function (seas_code, style_no)
                    {
                    var buyer_code = $scope.buyer_code.BUYER_CODE;
                            if ($scope.allcontrol === true)
                    {
                    $scope.forallDisable = true;
                            $http.get('getallcontrol', {params: {seas_code: seas_code, buyer_code: buyer_code, style_no: style_no}}).
                            success(function (response)
                            {
                            $scope.dataList = response;
                                    if ($scope.dataList.flag === 'false')
                            {
                            alert($scope.dataList.msg);
                            }
                            if ($scope.dataList.embflag === 'true')
                            {
                            $scope.showModal = true;
                                    $scope.isDisabled = true;
                            }
                            if ($scope.dataList.fabdis === 'true')
                            {
                            $scope.isDisabled = true;
                            }
                            });
                    }
                    };
                    $scope.getdata = function (seas_code, serial, colour)
                    {

                    $http.get('getdata', {params: {seas_code: seas_code, serial: serial, colour: colour}}).
                            success(function (response)
                            {
                            $scope.dataList = response;
                                    if ($scope.dataList.flag === 'false')
                            {
                            alert($scope.dataList.msg);
                            }
                            if ($scope.dataList.embflag === 'true')
                            {
                            $scope.showModal = true;
                                    $scope.isDisabled = true;
                            }
                            });
                    };
                    $scope.getembEntrymodal = function ()
                    {
                    $scope.showModal = true;
                    };
                    $scope.getWorkType = function ()
                    {
                    $http.get('getWorkType').
                            success(function (response)
                            {
                            $scope.worklist = response;
                            });
                    };
                    $scope.Ok = function (mode)
                    {
                    $scope.showModal = false;
                            var seas_code = $scope.seas_code;
                            var bcode = $('#buyer_code').val();
                            var style_no = $scope.style_no;
                            var serial = $scope.serial;
                            var colour = $scope.colour;
                            if (serial === undefined)
                    {
                    serial = 0;
                    }
                    if (colour === undefined)
                    {
                    colour = 0;
                    }

                    var allcontrol = document.getElementById("allcontrol").checked;
                            if (allcontrol === '')
                    {
                    allcontrol = false;
                    }
                    if (mode === 'Y')
                    {
                    $('#otherdetails').show();
                            $http.get('getOtherDetails', {params: {seas_code: seas_code, style_no: style_no, serial: serial, allcontrol: allcontrol, colour: colour}}).
                            success(function (response)
                            {
                            $scope.otherdetails = response;
                                    $scope.getWorkType();
                            });
                    }
                    if (mode === 'N')
                    {
                    $('#otherdetails').hide();
                    }

                    };
                    $scope.Cancel = function () {
                    $scope.showModal = false;
                    };
                    $scope.submit = function () {
                    var formdata = 
                        {
                             "seas_code": $('#seas_code').val(),
                            "serial": $scope.serial,
                            "buyer_code": $('#buyer_code').val(),
                            "style_no": $('#style_no').val(),
                            "b_style": $('#b_style').val(),
                            "colour": $scope.colour,
                            "intfab_rate": $('#fab_rateIN').val(),
                            "fab_rate" :$('#fab_rate').val(),
                           "hd_rate":$('#hand_emb').val(),
                            "mc_rate":$('#mach_emb').val(),
                            "ar_rate":$('#aari_emb').val(),
                            "others":$('#others1').val(),
                            "oth1":$('#others2').val(),
                            "oth2":$('#others3').val(),
                            "oth3":$('#others4').val(),
                            "oth4":$('#others5').val(),
                            "oth5":$('#others6').val(),
                            "oth6":$('#others7').val(),
                            "oth7":$('#others8').val(),
                            "oth8":$('#others9').val(),
                            "oth9":$('#others10').val(),
                            "oth_desc":$('#othersd1').val(),
                            "oth1_desc":$('#othersd2').val(),
                            "oth2_desc":$('#othersd3').val(), 
                            "oth3_desc":$('#othersd4').val(),
                            "oth4_desc":$('#othersd5').val(),
                            "oth5_desc":$('#othersd6').val(),
                            "oth6_desc":$('#othersd7').val(), 
                            "oth7_desc":$('#othersd8').val(), 
                            "oth8_desc":$('#othersd9').val(),
                            "oth9_desc":$('#othersd10').val(),
                            "allcontrol" : document.getElementById("allcontrol").checked
                        };
                            $http.post('updateFabRateEntry', formdata).
                            success(function (response)
                            {
                            $scope.updateResult = response;
                            alert($scope.updateResult.msg);
                            });
                    };
                    $scope.reset = function ()
                    {
                    $scope.seasonbean.seas_desc = "";
                            $scope.buyer_code = "";
                            $scope.b_style = "";
                            $scope.style_no = "";
                            $scope.controldata = "";
                            $scope.serial = "";
                            $scope.colour = "";
                            $scope.fab_rateIN = "";
                            $scope.fab_rate = "";
                            $('#otherdetails').hide();
                    };
                    var total = 0;
                    $scope.load = function(othersd1){
                    $scope.othersd1 = othersd1;
                    };
            }]);        </script>
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
            input.ng-invalid-required{
                border-left: 5px solid #990000;
            }

            input.ng-valid-required{
                //border-left: 5px solid #009900;
            }

            legend {
                width:inherit; 
                padding:0 10px; 
                font-size: 13px;
                border: 2px solid #333;
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
            <div class="panel panel-info" style='width:80%;margin-left: 8%'>
                <div class="panel-heading">Fab Rate/Emb Rate Entry</div>
                <div class="panel-body">
                    <form  class="form-horizontal" name="myform" ng-submit="submit()" nonvalidate>  
                        <div class="row">
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-2">Select Season</label>
                                    <div data-ng-init="populateSeasList()"  class="col-sm-5" >
                                        <select id="seas_code" ng-model="seas_code" name="seas_code" required ng-change="getSeasonDesc()" ng-blur="getBuyerCode(seas_code)" class="form-control" >
                                            <option value="" >Select Season</option>
                                            <option data-ng-repeat="s in season" value="{{s.seas_code}}">{{s.seas_code}}</option>
                                        </select> 
                                        <span ng-show="myform.seas_code.$invalid && myform.seas_code.$error.required" style="color: red">Required.</span>
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
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-2">Buyer Code</label>
                                    <div class="input-group col-sm-4">
                                        <!--   <select ng-model="buyer_code" name="buyer_code" id="buyer_code" class="form-control"  >
                                                    <option value="" >Select Buyer</option>
                                                    <option  ng-repeat="b in buyercode" value="{{b.BUYER_CODE}}">{{b.BUYER_CODE}}</option>
                                              </select>-->
                                        <select ng-model="buyer_code" name="buyer_code" id="buyer_code" class="form-control" required
                                                ng-options="s.BUYER_CODE for s in buyercode track by s.BUYER_CODE" ng-blur="getStyleNo(seas_code, mode)"> 
                                          <option value="">--Please Select--</option>
                                        </select>
                                        <span ng-show="myform.buyer_code.$invalid && myform.buyer_code.$error.required" style="color: red">Required.</span>

                                    </div>
                                    {{buyer_code.BUYER_NAME}}
                                </div>
                            </div>
                            <div class="col-md-3" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Style No.</label>
                                    <div class="input-group col-sm-4">
                                        <select ng-model="style_no" name="style_no" id="style_no" class="form-control" required ng-blur="getSerial(seas_code, style_no)">
                                            <option value="">--Please Select--</option>
                                            <option ng-repeat="style in stylenolist" value="{{style.style_no}}">{{style.style_no}}</option>
                                        </select>
                                       <span ng-show="myform.style_no.$invalid && myform.style_no.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                            <div class="col-md-2" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">All Control#</label>
                                    <div class="input-group col-sm-1">
                                        <input type="checkbox" name="allcontrol" id="allcontrol" ng-model="allcontrol" checked="true" ng-blur="getallcontrol(seas_code, style_no)"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Serial</label>
                                    <div class="input-group col-sm-5">
                                        <select ng-model="serial" name="serial" id="serial" class="form-control" ng-init="" ng-blur="getColour(seas_code, style_no, serial)" ng-disabled="forallDisable">
                                            <option ng-repeat="ser in seriallist" value="{{ser.SERIAL}}">{{ser.SERIAL}}</option>
                                        </select>
                                        <span ng-show="myform.serial.$touched && myform.serial.$error.required" style="color: red">Required.</span>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Colour</label>
                                    <div class="input-group col-sm-5">
                                        <select ng-model="colour" name="colour" id="colour" class="form-control" ng-init="" ng-blur="getdata(seas_code, serial, colour)" ng-disabled="forallDisable">
                                            <option ng-repeat="col in colourlist" value="{{col.COLOUR}}">{{col.COLOUR}}</option>
                                        </select>
                                        <span ng-show="myform.colour.$touched && myform.colour.$error.required" style="color: red">Required.</span>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Buyer Style</label>
                                    <div class="input-group col-sm-4">
                                        <input type="text"  id="b_style" name="b_style" readonly ng-model="b_style" ng-value="dataList.B_STYLE" class="form-control" style="border:0px"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1"> Style No</label>
                                    <div class="input-group col-sm-3">
                                        <input type="text"  id="style_no" name="style_no" readonly ng-model="style_no" ng-value="dataList.STYLE_NO" class="form-control" style="border:0px"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Order Quantity</label>
                                    <div class="input-group col-sm-3">
                                        <input type="text"  id="order_qty"  readonly ng-model="order_qty" ng-value="dataList.ORDER_QTY" class="form-control" style="border:0px"/>
                                    </div>
                                </div>

                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Fabrication Rate</label>
                                    <div class="input-group col-sm-5">
                                        <input type="number"  id="fab_rate"  name="fab_rate" ng-model="fab_rate" ng-value="dataList.fab" ng-disabled="isDisabled" class="form-control" />
                                        <span ng-show="myform.fab_rate.$touched && myform.fab_rate.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-5">Fabrication Rate (IN)</label>
                                    <div class="input-group col-sm-5">
                                        <input type="number"  id="fab_rateIN"  name="fab_rateIN" ng-model="fab_rateIN" ng-value="dataList.fabin" class="form-control" ng-blur="getembEntrymodal()" />
                                        <span ng-show="myform.fab_rateIN.$touched && myform.fab_rateIN.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="otherdetails" style="font-size: 11px">
                            <fieldset title="Other Details">
                                <legend>Other Details</legend>
                                <div class="row">
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Hand Embroidery</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="hand_emb"  name="hand_emb" ng-model="hand_emb" ng-value="otherdetails.HD_RATE"  class="form-control" />
                                                <span ng-show="myform.fab_rate.$touched && myform.fab_rate.$error.required" style="color: red">Required.</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Machine Embroidery</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="mach_emb"  name="mach_emb" ng-model="mach_emb" ng-value="otherdetails.MC_RATE" class="form-control" />
                                                <span ng-show="myform.fab_rateIN.$touched && myform.fab_rateIN.$error.required" style="color: red">Required.</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Aari Embroidery</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="aari_emb"  name="aari_emb" ng-model="aari_emb" ng-value="otherdetails.AR_RATE" class="form-control" />
                                                <span ng-show="myform.fab_rateIN.$touched && myform.fab_rateIN.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <div class="row">
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 1</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others1"  name="others1" ng-model="others1" ng-value="otherdetails.OTHERS"  class="form-control" />
                                                <span ng-show="myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 2</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others2"  name="others2" ng-model="others2" ng-value="otherdetails.OTH1"  class="form-control" />
                                                <span ng-show=" myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 3</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others3"  name="others3" ng-model="others3" ng-value="otherdetails.OTH2"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 4</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others4"  name="others4" ng-model="others4" ng-value="otherdetails.OTH3"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 5</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others5"  name="others5" ng-model="others5" ng-value="otherdetails.OTH4"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>

                                </div>
                                <div class="row">

                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 6</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others6"  name="others6" ng-model="others6" ng-value="otherdetails.OTH5"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 7</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others7"  name="others7" ng-model="others7" ng-value="otherdetails.OTH6"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 8</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others8"  name="others8" ng-model="others8" ng-value="otherdetails.OTH7"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 9</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others9"  name="others9" ng-model="others9" ng-value="otherdetails.OTH8"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-2" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-5">Others 10</label>
                                            <div class="input-group col-sm-5">
                                                <input type="number"  id="others10"  name="others10" ng-model="others10" ng-value="otherdetails.OTH9"  class="form-control" />
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                </div>
 
                                <div class="row">
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-1">Others Details 1</label>
                                            <div class="input-group col-sm-6">
                                                <input class="form-control" id="othersd1" type="text" ng-model="othersd1" ng-value="otherdetails.OTHDESC" ng-required="others1" ng-readonly="othersd1.length > 0" >
                                                <div class="input-group-btn">
                                                    <select ng-model="othersd1" name="othersd1" id="othersd1" class="form-control"  >
                                                        <option value="">--Please Select--</option>
                                                        <option ng-repeat="work in worklist" value="{{work.NATURE_DESC}}">{{work.NATURE_DESC}} {{work.NATURE_WK}}  {{work.WORK_SEQ}}</option>
                                                          
                                                    </select>
                                                  
                                                </div>
                                                <span ng-show="myform.othersd1.$dirty && myform.othersd1.$error.required" style="color: red">Required.</span>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-1">Others Details 2</label>
                                            <div class="input-group col-sm-6">
                                                <input class="form-control" id="othersd2" type="text" ng-model="othersd2" ng-value="otherdetails.OTH1DESC" ng-required="others2"  >
                                                <div class="input-group-btn">
                                                <select ng-model="othersd2" name="othersd2" id="othersd2" class="form-control" >
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_DESC}}">{{work.NATURE_DESC}} {{work.NATURE_WK}}  {{work.WORK_SEQ}}</option>
                                                </select>
                                                </div>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-1">Others Details 3</label>
                                            <div class="input-group col-sm-6">
                                                <input type="text"  id="othersd3"  name="othersd3" ng-model="othersd3" ng-value="otherdetails.OTH2DESC"  class="form-control" ng-required="others3"/>
                                                 <div class="input-group-btn">
                                                <select ng-model="othersd3" name="othersd3" id="othersd3" class="form-control"  >
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_DESC}}">{{work.NATURE_DESC}} {{work.NATURE_WK}}  {{work.WORK_SEQ}}</option>
                                                </select>
                                                 </div>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                </div>
                                 <div class="row">
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-1">Others Details 4</label>
                                            <div class="input-group col-sm-6">
                                                <input type="text"  id="othersd4"  name="othersd4" ng-model="othersd4" ng-value="otherdetails.OTH3DESC"  class="form-control" ng-required="others4" />
                                                 <div class="input-group-btn">
                                                <select ng-model="othersd4" name="othersd4" id="othersd4" class="form-control"  >
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_DESC}}">{{work.NATURE_DESC}} {{work.NATURE_WK}}  {{work.WORK_SEQ}}</option>
                                                </select>
                                                 </div>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-1">Others Details 5</label>
                                            <div class="input-group col-sm-6">
                                                <input type="text"  id="othersd5"  name="othersd5" ng-model="othersd5" ng-value="otherdetails.OTH4DESC"  class="form-control" ng-required="others5" />
                                                 <div class="input-group-btn">
                                                <select ng-model="othersd5" name="othersd5" id="othersd5" class="form-control"   >
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_DESC}}">{{work.NATURE_DESC}} {{work.NATURE_WK}}  {{work.WORK_SEQ}}</option>
                                                </select>
                                                 </div>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                     <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-1">Others Details 6</label>
                                            <div class="input-group col-sm-6">
                                                <input type="text"  id="othersd6"  name="othersd6" ng-model="othersd6" ng-value="otherdetails.OTH5DESC"  class="form-control" ng-required="others6"/>
                                                 <div class="input-group-btn">
                                                <select ng-model="othersd6" name="othersd6" id="othersd6" class="form-control"   >
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_DESC}}">{{work.NATURE_DESC}} {{work.NATURE_WK}} {{work.WORK_SEQ}}</option>
                                                </select>
                                                 </div>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                </div>                        
                                <div class="row">
                                    
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-1">Others Details 7</label>
                                            <div class="input-group col-sm-6">
                                                <input type="text"  id="othersd7"  name="othersd7" ng-model="othersd7" ng-value="otherdetails.OTH6DESC"  class="form-control" ng-required="others7" />
                                                <div class="input-group-btn">
                                                <select ng-model="othersd7" name="othersd7" id="othersd7" class="form-control"   >
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_DESC}}">{{work.NATURE_DESC}} {{work.NATURE_WK}}  {{work.WORK_SEQ}}</option>
                                                </select>
                                                </div>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-1">Others Details 8</label>
                                            <div class="input-group col-sm-6">
                                                <input type="text"  id="othersd8"  name="othersd8" ng-model="othersd8" ng-value="otherdetails.OTH7DESC"  class="form-control" ng-required="others8"  />
                                                 <div class="input-group-btn">
                                                <select ng-model="othersd8" name="othersd8" id="othersd8" class="form-control"  >
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_DESC}}">{{work.NATURE_DESC}} {{work.NATURE_WK}}  {{work.WORK_SEQ}}</option>
                                                </select>
                                                 </div>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-1">Others Details 9</label>
                                            <div class="input-group col-sm-6">
                                                <input type="text"  id="othersd9"  name="othersd9" ng-model="othersd9" ng-value="otherdetails.OTH8DESC"  class="form-control" ng-required="others9" />
                                                 <div class="input-group-btn">
                                                <select ng-model="othersd9" name="othersd9" id="othersd9" class="form-control"   >
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_DESC}}">{{work.NATURE_DESC}} {{work.NATURE_WK}}  {{work.WORK_SEQ}}</option>
                                                </select>
                                                 </div>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>

                                            </div>
                                        </div>
                                    </div>
                                    <div class="col-md-4" >
                                        <div class="form-group">
                                            <label class="control-label col-sm-1">Others Details 10</label>
                                            <div class="input-group col-sm-6">
                                                <input type="text"  id="othersd10"  name="othersd10" ng-model="othersd10" ng-value="otherdetails.OTH9DESC"  class="form-control" ng-required="others10"/>
                                                <div class="input-group-btn">
                                                <select ng-model="othersd10" name="othersd10" id="othersd10" class="form-control"   >
                                                    <option value="">--Please Select--</option>
                                                    <option ng-repeat="work in worklist" value="{{work.NATURE_DESC}}">{{work.NATURE_DESC}} {{work.NATURE_WK}}  {{work.WORK_SEQ}}</option>
                                                </select>
                                                </div>
                                                <span ng-show="myform.others1.$touched && myform.others1.$error.required" style="color: red">Required.</span>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </fieldset>
                        </div>
                          <button type="button" ng-click="reset()"  class="btn btn-primary">Reset</button>
                        <input type="submit"  value="Update" />
                           </form>
                </div>
            </div>
        </div>
        <div modal="showModal" close="cancel()">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" ng-click="Cancel()">&times;</button>
            </div>
            <div class="modal-body">
                <fieldset >
                    <p>Do you want to enter  Embroidery Rates</p>
                    <fieldset>
                        <label class="radio-inline"> <input type="radio" id="mode" name="mode" ng-model="mode" value="Y"  />Yes</label>
                        <span ng-show="myform.mode.$touched && myform.mode.$error.required" style="color: red">Required.</span>

                        <label class="radio-inline"> <input type="radio" id="mode" name="mode" ng-model="mode" value="N" />No</label>
                    </fieldset>
                </fieldset>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-success" ng-click="Ok(mode)">OK</button>
                <button type="button" class="btn btn-success" ng-click="Cancel()">Cancel</button>

            </div>
        </div>

    </body>
</html>
