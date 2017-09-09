<%-- 
    Document   : InvoiceEntry
    Created on : Aug 10, 2017, 11:03:24 AM
   Author     : Supriya Kare
--%>



<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html data-ng-app="myApp" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Invoice Entry</title>

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


        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-dialog/1.34.7/css/bootstrap-dialog.min.css">
        <script type="text/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap3-dialog/1.34.7/js/bootstrap-dialog.min.js"></script>
        <script>

            var myApp = angular.module('myApp', ["ui.bootstrap.modal"]);
            myApp.controller("myCtrl", ['$scope', '$http', function ($scope, $http)
                {
                    $scope.formdata = {};
                    $scope.total = 0;
                    $('#sizewiseqty').hide();
                    $('#shipdata').hide();
                    $('#article').hide();
                     $('#allother').hide();
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
                    $scope.getBuyerCode = function (seas_code, style_no)
                    {
                        if (($('#seas_code').val() !== '') && ($('#style_no').val() !== ''))
                        {
                            $http.get('getBuyerCodeOnstyle', {params: {seas_code: seas_code, style_no: style_no}}).
                                    success(function (response)
                                    {
                                        $scope.buyercode = response;
                                        if ($scope.buyercode.flag === 'false')
                                        {
                                            alert($scope.buyercode.msg);
                                            console.log($scope.buyercode.msg);
                                        }

                                    });
                        }
                    };
                    $scope.getStyleNo = function (seas_code)
                    {

                        if ($('#seas_code').val() !== '')
                        {
                            $http.get('getStyleNoOnSeason', {params: {seas_code: seas_code}}).
                                    success(function (response)
                                    {
                                        $scope.stylenolist = response;
                                        if ($scope.stylenolist.flag === 'false')
                                        {
                                            alert($scope.stylenolist.msg);
                                        }

                                    });
                        }
                    };
                    $scope.getOrderdata = function ()
                    {
                        var buyer_code = $scope.buyer_code.BUYER_CODE;
                        var seas_code = $scope.seas_code;
                        var style_no = $scope.style_no;
                        $http.get('getOrderdataforInvoiceEntry', {params: {seas_code: seas_code, buyer_code: buyer_code, style_no: style_no}}).
                                success(function (response)
                                {
                                    $scope.orderdatalist = response;
                                    $('#shipdata').show();
                                    $('#toship0').focus();
                                    $('#error').hide();

                                });


                    };
                    $scope.index = [];
                    $scope.getshipdata = function (serial, colour, index1, order_per, raise)
                    {
                        index = index1;
                        var seas_code = $scope.seas_code;
                        var buyer_code = $scope.buyer_code.BUYER_CODE;
                        var style_no = $scope.style_no;
                        $http.get('getOrderdataforInvoiceEntryClick', {params: {seas_code: seas_code, buyer_code: buyer_code, style_no: style_no, serial: serial, colour: colour}}).
                                success(function (response)
                                {
                                    $scope.orderdatalistclick = response;
                                    if ($scope.orderdatalistclick.sizewiseqtyflag === 'true')
                                    {
                                        $('#sizewiseqty').show();
                                        $scope.allowed = order_per;
                                        $scope.raise = raise;
                                        $('#error').hide();
                                    }
                                    if ($scope.orderdatalistclick.disp.articleflag === 'true')
                                    {
                                         $('#article').show();
                                    }
                                });
                    };
                    $scope.getShippingUnit = function ()
                    {
                        var buyer_code = $scope.buyer_code.BUYER_CODE;
                        var comp_code = $('#comp_code').val();
                        $http.get('getShippingUnit', {params: {buyer_code: buyer_code, comp_code: comp_code}}).
                                success(function (response)
                                {
                                    $scope.shippingunit = response;
                                    // console.log(response);
                                });
                    };
                    $scope.getWorkUnit = function ()
                    {
                        var buyer_code = $scope.buyer_code.BUYER_CODE;
                        var comp_code = $('#comp_code').val();
                        $http.get('getWorkUnit').
                                success(function (response)
                                {
                                    $scope.workunit = response;
                                    // console.log(response);
                                });
                    };

                    var tt = 0;
                    $scope.shipno = [];
                    $scope.alertmsg = function (msg)
                    {
                        BootstrapDialog.alert(msg);
                    };
                    $scope.ser = [];
                    $scope.col = [];
                    $scope.s = [];
                    $scope.getTotal = function (order_per, raised, toship, serial, colour, price, s)
                    {
                        var error;
                        ser = serial;
                        col = colour;
                        console.log(order_per + "  " + raised + "  " + toship);
                        if (toship !== '' || toship !== 0)
                        {
                            if ($('#fab_con').val() === '')
                            {
                                $scope.alertmsg('FABRIC CONTENT IS NOT ENTERED FOR THIS STYLE..');
                                setTimeout(function () {
                                    window.location.reload(true);
                                }, 2000);

                            }
                            if ($("#b_style").val() === '')
                            {
                                $scope.alertmsg('INVOICE CANNOT BE RAISED BUYER STYLE NOT FED IN..');
                                setTimeout(function () {
                                    window.location.reload(true);
                                }, 2000);
                            }
                            if ($("#price").val() === '')
                            {
                                $scope.alertmsg('INVOICE CANNOT BE RAISED PRICE IS NOT FED IN..');
                                setTimeout(function () {
                                    window.location.reload(true);
                                }, 2000);
                            }
                            if (+raised + +toship > order_per)
                            {
                                $scope.alertmsg('Quantity Raised Can Not Be Greater Than 10% Of Original Quantity!!');
                                error = 'true';

                                // $('#toship' + index).focus();
                                //    $('#toship' + index).val("");

                                //   console.log('quantity greater');
                                //   $('#toship' + index).val(0);

                                //   toship=0;
                            }
                            else
                            {
                                   $('#allother').show();
                                $http.get('Trunctempship');
                                angular.forEach($scope.orderdatalist.shipdata, function (value, key) {
                                    console.log("key" + key);
                                    console.log("valuetoship " + $('#toship' + key).val());
                                    var ship = $('#toship' + key).val();
                                    if (ship === '')
                                    {
                                        ship = 0;
                                    }
                                    console.log(ship);
                                    // if($('#toship'+ key).val() > 0){
                                    $http.get('Inserttempship', {params: {serial: value.serial, colour: value.colour, price: value.price, toship: ship}}).
                                            success(function (response)
                                            {
                                                $scope.tempship = response;
                                                // console.log(response);
                                            });
                                    // }
                                });
                            }
                        }
                        if (error === 'true')
                        {
                            console.log('in error');
                            $('#toship' + index).val(0);
                            s.toship = 0;
                            $('#toship' + +index + +1).focus();
                            toship = 0;
                        }
                        var tot = 0;
                        for (var i = 0; i < $scope.orderdatalist.shipdata.length; i++)
                        {
                            tot = +tot + +$('#toship' + i).val();
                            console.log("total i for" + tot);
                            $scope.total = tot;
                        }
            <%--  $scope.total = angular.forEach($scope.orderdatalist.shipdata, function (value, key) {
                  //console.log(key + ': ' + value.toship);
                  tot = tot + value.toship;
                  console.log(tot);
                  $('#total').val(tot);
                  $scope.total = tot;

                        });--%>
                        $scope.total = tot;

                        // console.log('total   '+tt);
                    };

                    $scope.s = [];
                    $scope.getTotalShip = function (serial, colour)
                    {

                        var tottoraise = 0;
            <%--    angular.forEach($scope.orderdatalistclick.sizewiseqty, function (value, key) {
                    console.log(key + ': ' + value.toraise);
                    tottoraise = tottoraise + value.toraise;

                        });--%>
                        for (var i = 0; i < $scope.orderdatalistclick.sizewiseqty.length; i++)
                        {
                            tottoraise = +tottoraise + +$('#toraise' + i).val();
                            console.log('tottoraise  ' + tottoraise);
                        }
                        var raise = $('#raise').val();
                        var allowed = $('#allowed').val();

                        // console.log('tottoraise--------' + tottoraise);
                        //console.log('raise-----' + raise);
                        // console.log('allowed-----' + allowed);
                        if ((+tottoraise + +raise) > allowed)
                        {
                            alert('Invoice cannot be raised more than Allowed qty');
                        }
                        else {
                            //  console.log(tottoraise);
                            //$scope.orderdatalist.shipdata.shipno=tottoraise;
                            $('#toship' + index).val(tottoraise);
                            var next = +index + +1;
                            $('#toship' + next).focus();
                            var tempinvoice =
                                    {
                                        'size': $scope.orderdatalistclick.sizewiseqty,
                                        'serial': ser,
                                        'colour': col

                                    };
                            $http.post('InsertIntotempInvoice', tempinvoice).success(function (response)
                            {
                                $scope.res = response;
                                // console.log(res);
                            });
                        }
                    };
                    $scope.submit = function ()
                    {
                        var shipdata =
                                {
                                    'data': $scope.orderdatalist.shipdata,
                                    'size': $scope.orderdatalistclick.sizewiseqty,
                                    'seas_code': $scope.seas_code,
                                    'buyer_code': $scope.buyer_code.BUYER_CODE,
                                    'style_no': $scope.style_no,
                                    'port': $scope.port,
                                    'b_style': $('#b_style').val(),
                                    'netstyleradio': $scope.netstyleradio,
                                    'shipmentradio': $scope.shipmentradio,
                                    'setradio': $scope.setradio,
                                    'modeship': $scope.modeship,
                                    'shipunit': $scope.shipunit.UNIT,
                                    'workuint': $scope.shipunit1.UNIT1
                                };
                        $http.post('saveInvoiceenrty', shipdata).
                                success(function (response)
                                {
                                    $scope.res = response;
                                    // console.log(response);
                                });
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
            input.ng-invalid-required{
                border-left: 5px solid #990000;
            }

            input.ng-valid-required{
                //border-left: 5px solid #009900;
            }

            legend {
                width:inherit; 
                padding:0 10px; 
                line-height:20px;
                font-size: 12px;
                border: 1px solid #333;
                margin-bottom:0px;
            }
            fieldset { border:1px solid lightblue;
            margin: 8px;
            padding: 5px;
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
                <div class="panel-heading">Invoice Entry</div>
                <div class="panel-body">
                    <form  class="form-horizontal" name="myform" ng-submit="submit()" nonvalidate>  
                        <div class="row">
                            <div class="col-md-4" >
                                <div class="form-group">
                                    <label class="control-label col-sm-2">Select Season</label>
                                    <div data-ng-init="populateSeasList()"  class=" input-group col-sm-5" >
                                        <select id="seas_code" ng-model="seas_code" name="seas_code" required ng-change="getSeasonDesc()" ng-blur="getStyleNo(seas_code)" class="form-control" >
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
                            <div class="col-md-3" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Style No.</label>
                                    <div class="input-group col-sm-4">
                                        <select ng-model="style_no" name="style_no" id="style_no" class="form-control" required ng-blur="getBuyerCode(seas_code, style_no)">
                                            <option value="">--Please Select--</option>
                                            <option ng-repeat="style in stylenolist.style_no" value="{{style.STYLE_NO}}">{{style.STYLE_NO}}</option>
                                        </select>
                                        <span ng-show="myform.style_no.$invalid && myform.style_no.$error.required" style="color: red">Required.</span>

                                    </div>
                                </div>
                            </div>
                            <div class="col-md-5" >
                                <div class="form-group ">
                                    <label class="control-label col-sm-2">Buyer Code</label>
                                    <div class="input-group col-sm-4">

                                        <select ng-model="buyer_code" name="buyer_code" id="buyer_code" class="form-control" required ng-change="getOrderdata()"
                                                ng-options="s.BUYER_CODE for s in buyercode.buyer_code track by s.BUYER_CODE" > 
                                            <option value="">--Please Select--</option>
                                        </select>
                                        <span ng-show="myform.buyer_code.$invalid && myform.buyer_code.$error.required" style="color: red">Required.</span>

                                    </div>
                                    {{buyer_code.BUYER_NAME}}
                                </div>
                            </div>
                        </div>
                        <fieldset title="Other Details">
                            <legend>Details</legend>
                            <div style="margin: 10px">
                            <div class="row">
                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Buyer Code</label>
                                        <div class="input-group col-sm-4">
                                            <input class="form-control" id="buyer_code" type="text"  ng-model="buyer_coded" ng-value="orderdatalistclick.disp.buyer_code" readonly>

                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Buyer Style</label>
                                        <div class="input-group col-sm-4"> 
                                            <input type="text"  id="b_style" data-ng-model="b_style" ng-value="orderdatalistclick.disp.b_style" class="form-control" readonly/>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-5" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Garment Description</label>
                                        <div class="input-group col-sm-6"> 
                                            <input type="text"  id="gar_desc" ng-model="gar_desc" data-ng-value="orderdatalistclick.disp.gar_desc" class="form-control" readonly/>
                                        </div>
                                    </div>
                                </div>


                            </div>
                            <div class="row">
                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Price</label>
                                        <div class="input-group col-sm-5"> 
                                            <input type="text" name="price" id="price" ng-model="price" ng-value="orderdatalistclick.disp.price" class="form-control" readonly/>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Already Raised</label>
                                        <div class="input-group col-sm-5"> 
                                            <input type="text"  id="alraised" ng-model="alraised" ng-value="orderdatalistclick.disp.alraised"  class="form-control" readonly/>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Currency</label>
                                        <div class=" input-group col-sm-4"> 
                                            <input type="text"  id="curr" name="curr" ng-model="curr" ng-value="orderdatalistclick.disp.currency"  class="form-control" readonly/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Wov/Hos/Swe</label>
                                        <div class="input-group col-sm-3"> 
                                            <input type="text"  id="wov_hos" name="wov_hos" ng-model="wov_hos" ng-value="orderdatalistclick.disp.wov_hos"  class="form-control" readonly/>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Order No</label>
                                        <div class="input-group col-sm-4"> 
                                            <input type="text"  id="order_no" ng-model="order_no" name="order_no" ng-value="orderdatalistclick.disp.order_no" class="form-control" readonly/>

                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1"> Order Date </label>
                                        <div class="input-group col-sm-5"> 
                                            <input type="text" ng-model="order_date" id="order_date" name="order_date" ng-value="orderdatalistclick.disp.order_date" class="form-control" readonly/>
                                        </div>
                                    </div>
                                </div>

                            </div>
                            <div class="row">

                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Quota Seg.</label>
                                        <div class="input-group col-sm-3"> 
                                            <input type="text"  id="quota_seg" name="quota_seg" ng-model="quota_seg"  ng-value="orderdatalistclick.disp.quota_seg"  class="form-control" readonly/>

                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Quota Cat.</label>
                                        <div class="input-group col-sm-3"> 
                                            <input type="text"  id="quota_cat" name="quota_cat" ng-model="quota_cat" data-ng-value="orderdatalistclick.disp.quota_cat"  class="form-control" readonly/>

                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-4" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Order Quantity</label>
                                        <div class="input-group col-sm-3"> 
                                            <input type="text"  id="order_qty" ng-model="order_qty" ng-value="orderdatalistclick.disp.order_qty"  class="form-control" readonly/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Company Code</label>
                                        <div class="input-group col-sm-3"> 
                                            <input type="text"  id="comp_code" ng-model="comp_code" ng-value="orderdatalistclick.disp.comp_code"  class="form-control" readonly/>

                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-3" >
                                    <label class="input-group col-sm-3">{{orderdatalistclick.disp.comp_name}}</label>
                                </div>
                                <div class="col-md-5" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Fabric content</label>
                                        <div class="input-group col-sm-7"> 
                                            <input type="text"  id="fab_con" ng-model="fab_con" ng-value="orderdatalistclick.disp.fab_con"  class="form-control" readonly/>
                                            <input type="text"  id="fab_con2" ng-model="fab_con2" ng-value="orderdatalistclick.disp.fab_con2"  class="form-control" readonly/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="row">
                                <div class="col-md-3" >
                                    <div class="form-group">
                                        <label class="control-label col-sm-1">Total</label>
                                        <div class="input-group col-sm-3"> 
                                            <input type="text"  id="total" ng-model="total" ng-value="total"  class="form-control" readonly/>
                                        </div>
                                    </div>
                                </div>
                            </div>
                                  </div>
                        </fieldset><br/>
                        <div class="row">
                             <div class="col-md-6" >
                            <div class="table-responsive" id="shipdata">          
                                <table class="table-bordered" style="width:80%">
                                    <thead>
                                        <tr><th class="col-sm-1">Serial</th>
                                            <th class="col-sm-1">Colour</th>
                                            <th class="col-sm-1">Order Qty</th>
                                            <th class="col-sm-1">{{orderdatalist.head}}</th>
                                            <th class="col-sm-1">Price</th>
                                            <th class="col-sm-1">Raised</th>
                                            <th class="col-sm-1">To-Ship</th>
                                        </tr>
                                    </thead>
                                    <tbody ng-repeat="s in orderdatalist.shipdata" >
                                        <tr >
                                            <td>{{s.serial}}</td>
                                            <td>{{s.colour}}</td>
                                            <td>{{s.order_qty}}</td>
                                            <td>{{s.order_per}}</td>
                                            <td>{{s.price}}</td>
                                            <td>{{s.raised}}</td>
                                            <td> <input type="number" name="toship" min="0" id="toship{{$index}}"  ng-model="s.toship" ng-focus ="getshipdata(s.serial, s.colour, [$index], s.order_per, s.raised)"   ng-blur ="getTotal(s.order_per, s.raised, s.toship, s.serial, s.colour, s.price, s)" style="width: 80px"/>
                                            </td>
                                        </tr>
                                    </tbody>
                                </table>
                            </div>
                        </div>
                         <div class="col-md-6" >
                            <div id="sizewiseqty">
                                <fieldset style="margin: 0px;padding: 0px;">
                                    <legend>Size Wise Qty</legend>
                                    <div class="row" style="padding-left: 20px;padding-top: 5px;">
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label class="control-label col-sm-1" style="width:90px">Order Qty</label>
                                                <div class="input-group col-sm-4"> 
                                                    <input type="text"  id="oqty" ng-model="oqty" ng-value="orderdatalistclick.disp.order_qty"  class="form-control" readonly/>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="form-group">
                                                <label class="control-label col-sm-1" style="width:90px">Raised</label>
                                                <div class="input-group col-sm-4"> 
                                                    <input type="text"  id="raise" ng-model="raise" ng-value="orderdatalistclick.disp.alraised"  class="form-control" readonly/>
                                                </div>
                                            </div>
                                        </div>
                                        <div class="col-md-4">
                                            <div class="form-group">
                                                <label class="control-label col-sm-1" style="width:90px">Allowed</label>
                                                <div class="input-group col-sm-4"> 
                                                    <input type="text"  id="allowed" ng-model="allowed" ng-value="orderdatalist.shipdata.order_per"  class="form-control" readonly/>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <div class="table-responsive">          
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr><th>Serial</th>
                                                    <th>Colour</th>
                                                    <th>Sizes</th>
                                                    <th>Order Qty</th>
                                                    <th>Prices</th>
                                                    <th>To-Raise</th>
                                                </tr>
                                            </thead>
                                            <tbody >
                                                <tr ng-repeat="s in orderdatalistclick.sizewiseqty" >
                                                    <td>{{s.serial}}</td>
                                                    <td>{{s.colour}}</td>
                                                    <td>{{s.Sizes}}</td>
                                                    <td>{{s.order_qty}}</td>
                                                    <td>{{s.prices}}</td>
                                                    <td>  <input type="number" min="0" name="toraise" id="toraise{{$index}}" ng-model="s.toraise" style="width: 80px" />
                                                        <span ng-show="myform.price.$touched && myform.price.$error.required" style="color: red">Required.</span></td>
                                                </tr>
                                                <tr><td><button type="button" ng-click="getTotalShip()" value="Add">Add</button></td></tr>
                                            </tbody>
                                        </table>

                                    </div>
                            </div>
                                </fieldset>
                            </div>
                        </div>
                        <div id="allother">
                        <div clas="row">
                            <div class="col-md-2" >
                                <div id="netstyle">
                                    <fieldset>
                                        <legend>Net Style</legend>

                                        <label class="radio-inline">
                                            <input type="radio" name="netstyleradio" ng-model="netstyleradio" value="Y" required>Yes
                                        </label>
                                        <label class="radio-inline">
                                            <input type="radio" name="netstyleradio" ng-model="netstyleradio" value="N" checked required>No
                                        </label><br/>
                                         <span ng-show="myform.netstyleradio.$invalid && myform.netstyleradio.$error.required" style="color: red">Required.</span>
                                    </fieldset>

                                </div>
                            </div>
                            <div class="col-md-3" >
                                <div id="netstyle">
                                    <fieldset>
                                        <legend>Shipment</legend>
                                        <label class="radio-inline">
                                            <input type="radio" name="shipmentradio" required ng-model="shipmentradio" value="FOB">FOB
                                        </label>
                                        <label class="radio-inline">
                                            <input type="radio" name="shipmentradio" required ng-model="shipmentradio" value="C&F">C/F
                                        </label>
                                        <label class="radio-inline">
                                            <input type="radio" name="shipmentradio" required ng-model="shipmentradio" value="FOBAIR">FOBAIR
                                        </label><br/>
                                        <span ng-show="myform.shipmentradio.$invalid &&  myform.shipmentradio.$error.required" style="color: red">Required.</span>
                                    </fieldset>
                                </div>
                            </div>
                            <div class="col-md-2" >
                                <div id="set">
                                    <fieldset>
                                        <legend>Set</legend>
                                        <label class="radio-inline">
                                            <input type="radio" name="setradio" required ng-model="setradio" value="Y" >YES
                                        </label>
                                        <label class="radio-inline">
                                            <input type="radio"  name="setradio" required ng-model="setradio" value="N" checked >NO
                                        </label><br/>
                                         <span ng-show="myform.setradio.$invalid && myform.setradio.$error.required" style="color: red">Required.</span>
                                    </fieldset>
                                </div>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-5" >
                                <div class="form-group">
                                    <br/><br/>
                                    <label class="control-label col-sm-3">Port Of Discharge</label>
                                    <div class="input-group col-sm-3"> 
                                        <input type="text" name="port" id="port" ng-model="port" class="form-control" required />
                                        <span ng-show="myform.port.$invalid && myform.port.$error.required" style="color: red">Required.</span>
                                    </div>
                                </div>
                            </div>
                           
                        </div>
                        <div clas="row">
                             <div class="col-md-3" >
                                <div id="modeofshipment">
                                    <div class="form-group">
                                        <fieldset>
                                            <legend>Mode Of shipment</legend>
                                            <div class="input-group col-sm-6">
                                            <select ng-model="modeship" name="modeship" id="modeship" class="form-control"  ng-focus ="getShippingUnit()" required>
                                                <option value="AIR">AIR</option>
                                                <option value="SEA">SEA</option>
                                                <option value="SKY BRIDGE">SKY BRIDGE</option> 
                                                <option value="SEA/AIR">SEA/AIR</option>
                                            </select>
                                            </div>
                                             <span ng-show="myform.modeship.$invalid && myform.modeship.$error.required" style="color: red">Required.</span>
                                        </fieldset>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-3" >
                                <div id="shipunitdiv">
                                    <div class="form-group">
                                        <fieldset>
                                            <legend>Shipping Unit</legend>
                                              <div class="input-group col-sm-6">
                                            <select ng-model="shipunit" name="shipunit" id="shipunit" ng-options="s.UNIT for s in shippingunit track by s.UNIT" class="form-control"  ng-focus="getWorkUnit()" required> 
                                            </select>
                                              </div>
                                            {{shipunit.NUNIT_NAME}}
                                            <span ng-show="myform.shipunit.$invalid && myform.shipunit.$error.required" style="color: red">Required.</span>
                                        </fieldset>

                                    </div>

                                </div>
                            </div>
                            <div class="col-md-3" >
                                <div id="workunitdiv">
                                    <div class="form-group">
                                        <fieldset>
                                            <legend>Work Unit</legend>
                                            <div class="input-group col-sm-6">
                                            <select ng-model="shipunit1" name="shipunit1" id="shipunit1" ng-options="s.UNIT1 for s in workunit track by s.UNIT1" class="form-control" required > 
                                            </select>
                                            </div>
                                            {{shipunit1.NUNIT_NAME1}}
                                             <span ng-show="myform.shipunit1.$invalid && myform.shipunit1.$error.required" style="color: red">Required.</span>
                                        </fieldset>

                                    </div>

                                </div>
                            </div>
                            <div class="col-md-3" >
                                <div id="article">
                                    <div class="form-group">
                                        <fieldset >
                                                <label class="control-label col-sm-1">Article No</label>
                                                <div class="input-group col-sm-3"> 
                                                    <input type="text"  id="articleno" ng-model="articleno" ng-value="orderdatalistclick.disp.articleno"  class="form-control" />
                                                </div>
                                                <label class="control-label col-sm-1">Dept</label>
                                                <div class="input-group col-sm-3"> 
                                                    <input type="dept"  id="dept" ng-model="dept" ng-value="orderdatalistclick.disp.dept"  class="form-control" />
                                                </div>
                                      
                                                <label class="control-label col-sm-1">Supplier</label>
                                                <div class="input-group col-sm-3"> 
                                                    <input type="supplier"  id="supplier" ng-model="supplier" ng-value="orderdatalistclick.disp.supplier"  class="form-control" />
                                                </div>
                                        </fieldset>

                                    </div>

                                </div>
                            </div>
                        </div>
                        </div>
                            <br/><br/><br/><br/><br/><br/>
                        <div clas="row">
                            <div class="col-md-3" >

                                <input type="submit"  value="Save" />
                                <button type="button" ng-click="reset()"  class="btn btn-primary">Reset</button>
                            </div>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </body>
</html>
<div class="modal fade" role="dialog" >
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
                <h4 class="modal-title">Modal title</h4>
            </div>
            <div class="modal-body">
                <p>aaaaaaa</p>
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">Close</button>
                <button type="button" class="btn btn-primary">Save changes</button>
            </div>
        </div><!-- /.modal-content -->
    </div><!-- /.modal-dialog -->
</div><!-- /.modal -->
