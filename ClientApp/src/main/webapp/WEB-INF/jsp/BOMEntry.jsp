<%-- 
    Document   : BOMEntry
    Created on : Aug 12, 2017, 12:06:42 PM
 Author     : Supriya Kare
--%>
<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html data-ng-app="myApp" >
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>BOM Entry</title>

        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
        <script src="<c:url value="/resources/js/app.js" />"></script>
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
        <script src="<c:url value="/resources/js/angular-ui-bootstrap-modal1.js" />"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-filter/0.5.16/angular-filter.js"></script>  



        <link href="<c:url value="/resources/css/bootstrap.min.css" />" rel="stylesheet">
        <link href="<c:url value="/resources/css/bootstrap.css" />" rel="stylesheet">
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.1/js/bootstrap.min.js"></script>
        <script src="https://cdnjs.cloudflare.com/ajax/libs/angular-filter/0.5.16/angular-filter.js"></script>  

        <script>

            var myApp = angular.module('myApp', ["ui.bootstrap.modal"]);
            myApp.controller("myCtrl", ['$scope', '$http', function ($scope, $http)
                {
                    $scope.formdata = {};
                    $scope.total = 0;

                    $('#shipdata').hide();
                    $('#basecode').hide();
                    $('#qtydiv').show();
                    $('#selBaseColorArray').hide();
                    $('#selItemColorArray').hide();
                    $scope.showModal = false;
                    $scope.showModalforCopy = false;
                    $scope.colourdisable = false;
                    $scope.qtydisable = false;
                    $scope.savedisable = true;
                    $scope.avgdone = true;
                    $scope.copydisable = true;
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
                    $scope.getSerial = function (seas_code)
                    {

                        $http.get('getSerialBomEntry', {params: {seas_code: seas_code}}).
                                success(function (response)
                                {
                                    $scope.seriallist = response;
                                    console.log(response);
                                });
                    };
                    $scope.getColour = function (seas_code, serial)
                    {
                        $http.get('getColourBom', {params: {seas_code: seas_code, serial: serial}}).
                                success(function (response)
                                {
                                    $scope.colourlist = response;
                                    console.log(response);
                                });
                    };
                    $scope.getColourList = function ()
                    {
                        $http.get('getColourListAll').
                                success(function (response)
                                {
                                    $scope.colourlistall = response;
                                   
                                });
                    };
                    $scope.getdata = function ()
                    {

                        var seas_code = $scope.seas_code;
                        var serial = $scope.serial;
                        var colour = $scope.colour.COLOUR_CODE;
                        $http.get('getBomDetails', {params: {seas_code: seas_code, serial: serial, colour: colour}}).
                                success(function (response)
                                {
                                    $scope.bomdetails = response;

                                });
                    };
                    $scope.bomadd = function (filename)
                    {
                        $scope.getBOMdata();

                        var part = $scope.part;
                        var seas_code = $scope.seas_code;
                        if (filename === 'add')
                        {
                            $http.get('getBOMAddNew', {params: {part: part, seas_code: seas_code}}).
                                    success(function (response)
                                    {
                                        $scope.populatecodeList();
                                        $scope.bomaddnewpage = response;
                                        $scope.showModal = true;
                                    });
                        }
                        else if (filename === 'copy')
                        {
                            $scope.showModalforCopy = true;
                        }
                        else if (filename === 'view')
                        {

                            $scope.showModalforView = true;
                        }
                        else
                        {

                        }
                    };
                    $scope.getFabGreyCode = function (fabcode)
                    {
                         $scope.code=$scope.codelists;
                        $http.get('getFabGreyCode', {params: {fabcode: fabcode}}).
                                success(function (response)
                                {
                                    $scope.fabric = response;
                                });
                    };
                    $scope.checkFabCode = function ()
                    {
                        var part = $scope.part;
                        var seas_code = $scope.seas_code;
                        var fabcode = $('#code').val();
                        var colour = $scope.colour.COLOUR_CODE;
                        var serial = $scope.serial;
                        $http.get('checkFabCode', {params: {fabcode: fabcode, part: part, seas_code: seas_code, colour: colour, serial: serial}}).
                                success(function (response)
                                {
                                    $scope.ckeckres = response;
                                    $scope.htype = $scope.ckeckres.htype;
                                    if ($scope.ckeckres.colourenableflag === 'true')
                                    {
                                        // $('#colour_code').focus();
                                        $scope.colourdisable = false;
                                    }
                                    else
                                    {
                                        $scope.colourdisable = true;
                                        $scope.colour_code = "28";
                                        // $scope.colour_code = $scope.ckeckres.colour;
                                        $scope.qtydisable = false;
                                    }
                                    if ($scope.ckeckres.lockcodeflag === 'true')
                                    {
                                        alert($scope.ckeckres.msg);
                                    }
                                    if ($scope.ckeckres.itemcodeerroeflag === 'true')
                                    {
                                        $('#code').focus();
                                        alert($scope.ckeckres.itemcodemsg);
                                    }
                                });
                    };
                    $scope.populatecodeList = function () {
                        var seas_code = $scope.seas_code;
                        var part = $scope.part;
                        //var seas_code = "51";
                        $http.get('getCodeList', {params: {seas_code: seas_code, part: part}}).
                                success(function (response)
                                {
                                    $scope.codelist = response;
                                    $scope.getColours();
                                    $scope.getCatalogList();
                                    $scope.getUOMList();
                                });
                    };
                    $scope.Save = function () {
                        var formdata = {
                            'seas_code': $scope.seas_code,
                            'serial': $scope.serial,
                            'colour': $scope.colour.COLOUR_CODE,
                            'code': $('#code').val(),
                            'colour_code': $('#colour_code').val(),
                            'part': $scope.part,
                            'base_code': $scope.base_code,
                            'base_colour': $scope.base_colour,
                            'qty': $('#qty').val(),
                            'avg': $('#avg').val(),
                            'width': $('#width').val(),
                            'uom': $scope.uom,
                            'catalog': $('#catalog').val(),
                            'htype': $scope.htype,
                            'buyer_code': $('#buyer_code').val()
                        };

                        var headers = {'Content-Type': 'application/x-www-form-urlencoded'};
                        var response = $http.post('saveBomAddNewData', formdata, headers);
                        response.success(function (data, status, headers, config) {
                            $scope.saveres = data;
                            alert($scope.saveres.msg);

                        });
                        // $scope.showModal = false;
                    };

                    $scope.cancel = function () {
                        $scope.showModal = false;
                    };
                    $scope.cancelViewModal = function () {
                        $scope.showModalforView = false;
                    };
                    $scope.cancelCopyModal = function () {
                        $scope.showModalforCopy = false;
                    };
                    $scope.showcodelist = function () {
                        //$('#codelist').show();
                    };
                    $scope.getColours = function () {

                        $http.get('getColoursAll').
                                success(function (response) {
                                    $scope.colours = response;
                                });
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
                    $scope.calcAvg = function (qty)
                    {
                        $scope.avgvalue = "";
                        var ordqty = $('#order_qty').val();
                        var avg = qty / ordqty;
                        result = avg.toFixed(3);
                        console.log(result);
                        $scope.avgvalue = result;
                        $scope.avgdone = true;
                        console.log(avg);

                    };
                    $scope.getwidth = function (w)
                    {
                        var width = $('#width').val();

                        if (width === '')
                        {
                            $scope.width = "N-A";
                        }
                    };
                    $scope.getcatalog = function ()
                    {
                        var catalog = $('#catalog').val();
                        var code = $('#code').val();
                        var part = $scope.part;
                        $http.get('checkcatalog', {params: {code: code, catalog: catalog, part: part}}).
                                success(function (response) {
                                    $scope.checkcatalog = response;
                                    if ($scope.checkcatalog.catalogflag === 'true')
                                    {
                                        alert($scope.checkcatalog.msg);

                                        $('#catalog').val('');
                                        // $('#catalog').focus();
                                    }
                                    else
                                    {
                                        $scope.catalog = "N-A";
                                    }

                                });


                    };

                    $scope.getcataloglist = function ()
                    {
                        $scope.showModalcataloglist = true;
                    };
                    $scope.getbasecodelist = function ()
                    {
                        var seas_code = $scope.seas_code;
                        var part = $scope.part;
                        $http.get('getbasecodelist', {params: {seas_code: seas_code, part: part}}).
                                success(function (response) {
                                    $scope.basecodelist = response;
                                });
                    };
                    $scope.checkitemcode = function ()
                    {
                        var seas_code = $scope.seas_code;
                        var part = $scope.part;
                        var colour = $scope.colour.COLOUR_CODE;
                        var serial = $scope.serial;
                        var code = $('#code').val();
                        var colour_code = $scope.colour_code;
                        $http.get('checkitemcode', {params: {seas_code: seas_code, part: part, colour: colour, serial: serial, code: code, colour_code: colour_code}}).
                                success(function (response) {
                                    $scope.checkitemcoderes = response;
                                    if ($scope.checkitemcoderes.repeatflag === 'true')
                                    {
                                        alert($scope.checkitemcoderes.msg);
                                        $scope.code = "";
                                        $scope.colour_code = "";
                                    }
                                    if ($scope.checkitemcoderes.colourenableflag === 'true')
                                    {
                                        $scope.colourdisable = false;
                                        alert($scope.checkitemcoderes.msgcolour);
                                    }
                                    if ($scope.checkitemcoderes.nocolorfoundflag === 'true')
                                    {

                                        alert($scope.checkitemcoderes.nocolourmsg);
                                    }

                                });

                    };
                    $scope.getBaseCodedata = function ()
                    {
                        var part = $('#part').val();
                        var code = $('#code').val();
                        var buyer_code = $('#buyer_code').val();
                        var htype = $scope.htype;
                        console.log('part  ' + part);
                        console.log('code  ' + code);
                        console.log('buyer_code  ' + buyer_code);
                        console.log('htype  ' + htype);
                        console.log(code.substring(0, 5));
                        code = code.trim();
                        code = code.toUpperCase();
                        console.log(code);
                        if (part === '1')
                        {
                            $scope.getbasecodelist();
                            $('#basecode').show();
                            $('#qtydiv').hide();
                            $scope.avgdone = false;
                        }
                        else if (part === '4' || htype === "ZIPS")
                        {
                            $('#qtydiv').show();
                        }
                        else if ((part === '3') && (htype === 'LABL') && ((code.substring(0, 5)) === 'N/SLB') && (buyer_code === 'NAPJ'))
                        {
                            $('#qtydiv').show();
                        }
                        else if ((part === '3') && (htype === "LABL") && ((code.substring(0, 5)) === 'N/SLB') && (buyer_code === 'AEMI'))
                        {

                            $('#qtydiv').show();
                        }
                        else if ((part === '3') && (htype === "LABL") && ((code.substring(0, 5)) === 'N/SLB') && (buyer_code === 'ODMO'))
                        {

                            $('#qtydiv').show();
                        }
                        else if ((part === '3') && (htype === "LABL") && ((code.substring(0, 5)) === 'N/SLB') && (buyer_code === 'MARC'))
                        {
                            $('#qtydiv').show();
                        }
                        else if ((part === '3') && (htype === "LABL") && ((code.substring(0, 5)) === 'N/SLB') && (buyer_code === 'BUGT'))
                        {
                            $('#qtydiv').show();
                        }
                        else if ((part === '3') && (htype === "LABL") && ((code.substring(0, 5)) === 'N/SLB') && (buyer_code === 'MNTC'))
                        {
                            $('#qtydiv').show();
                        }
                        else
                        {
                            $('#qtydiv').hide();
                            $scope.avgdone = false;
                            //$('#avg').focus();
                        }
                    };
                    $scope.checkapproved = function (radio)
                    {

                        if (radio === 'Y')
                        {
                            if (($('#avg').val().length > 0) && ($('#colour_code').val().length > 0) && ($('#width').val().length > 0) && ($('#uom').val().length > 0) && ($('#catalog').val().length > 0))
                            {
                                $scope.result = "Approved";
                                $scope.savedisable = false;
                            }
                            else
                            {
                                alert("PLEASE ENTER ALL ENTRIES");
                            }
                        }
                        else
                        {
                            if (($('#avg').val().length > 0) && ($('#colour_code').val().length > 0) && ($('#width').val().length > 0) && ($('#uom').val().length > 0) && ($('#catalog').val().length > 0))
                            {
                                $scope.result = "Not Approved";
                                $scope.savedisable = false;
                            }
                            else
                            {
                                alert("PLEASE ENTER ALL ENTRIES");
                            }
                        }
                    };
                    $scope.getBOMdata = function ()
                    {
                        var part = $scope.part;
                        var seas_code = $scope.seas_code;
                        var colour = $scope.colour.COLOUR_CODE;
                        var serial = $scope.serial;
                        $http.get('getBOMdata', {params: {seas_code: seas_code, part: part, colour: colour, serial: serial}}).
                                success(function (response) {
                                    $scope.bomdata = response;
                                    if (part === '4')
                                    {
                                        $scope.qtydisable = false;
                                    }

                                });
                    };
                    $scope.getcopydata = function ()
                    {
                        var part = $scope.part;
                        var seas_code = $scope.seas_code;
                        var colour = $scope.colour.COLOUR_CODE;
                        var serial = $scope.serial;
                        $http.get('getBOMCopydata', {params: {seas_code: seas_code, part: part, colour: colour, serial: serial}}).
                                success(function (response) {
                                    $scope.bomcopydata = response;
                                    if ($scope.bomcopydata.nodataflag === 'true')
                                    {
                                        alert($scope.bomcopydata.msg);
                                    }
                                });
                                   $scope.getColourList();
                                  
                    };

                    $scope.setItemcolour = function (checkboxval)
                    {
                            $scope.selItemCode = [{}];
                            $scope.selSerial = [{}];
                            $scope.selItemColorArray = [{}];
                            angular.forEach($scope.bomcopydata.bomdata, function (bom) {
                                if (bom.selitem)
                                    $scope.selItemCode.push({item_code: bom.item_code, base_code: bom.base_code});
                            });
                            angular.forEach($scope.bomcopydata.seriallist, function (bom) {
                                if (bom.selcontrol)
                                    $scope.selSerial.push({serial: bom.serial, colour: bom.colour});
                            });

                            angular.forEach($scope.selItemCode, function (item) {
                            angular.forEach($scope.selSerial, function (ser) {
                                    console.log(ser.colour + "  " + item.item_code);
                                 
                                    if (ser.serial !== undefined && ser.colour !== undefined && item.item_code !== undefined)
                                    {
                                        $scope.selItemColorArray.push({serial: ser.serial, colour: ser.colour, item_code: item.item_code, base_code: item.item_code});
                                    }
                               
                                });
                            });
                             $scope.selItemColorArray.splice(0, 1);
                               $('#selItemColorArray').show();
                                $scope.setBaseColour();
                                 $scope.copydisable=false;
                                                   
                    };
                    
                    $scope.setBaseColour=function()
                    {
                      
                          $scope.selItemCode = [{}];
                            $scope.selSerial = [{}];
                            $scope.selBaseColorArray = [{}];
                            angular.forEach($scope.bomcopydata.bomdata, function (bom) {
                                if (bom.selitem)
                                    $scope.selItemCode.push({item_code: bom.item_code, base_code: bom.base_code});
                            });
                            angular.forEach($scope.bomcopydata.seriallist, function (bom) {
                                if (bom.selcontrol)
                                    $scope.selSerial.push({serial: bom.serial, colour: bom.colour});
                            });

                            angular.forEach($scope.selItemCode, function (item) {
                                angular.forEach($scope.selSerial, function (ser) {
                                    console.log(ser.colour + "  " + item.item_code);
                                    if (ser.serial !== undefined && ser.colour !== undefined && item.item_code !== undefined)
                                    {
                                        $scope.selBaseColorArray.push({serial: ser.serial, colour: ser.colour, item_code: item.item_code,obase_code:item.base_code, base_code: item.base_code});
                                    }

                                });
                            });
                             $scope.selBaseColorArray.splice(0, 1);
                             $('#selBaseColorArray').show();
                    };
                    
                  $scope.s=[];
                    $scope.changeItemcolour=function(s,itemcode,itemcolour_code)
                    {
                        console.log(itemcode+" "+itemcolour_code);
                        var newitemcode=itemcode.substring(0, 9) + itemcolour_code;
                         console.log('newitemcode   '+newitemcode);
                          s.item_code=newitemcode;
                       
                    };
                     $scope.changeBasecolour=function(s,basecode,itemcolour_code)
                    {
                        console.log(basecode+" "+itemcolour_code);
                        var newitemcode=basecode.substring(0, 9) + itemcolour_code;
                         console.log('newitemcode   '+newitemcode);
                          s.base_code=newitemcode;
                       
                    };
                    $scope.saveCopyData=function()
                    {
                        var formdata={
                            'selItemColorArray':$scope.selItemColorArray,
                            'selBaseColorArray':$scope.selBaseColorArray,
                            'seas_code':$scope.seas_code,
                            'serial':$scope.serial,
                            'colour':$scope.colour.COLOUR_CODE,
                            'part' : $scope.part
                        };
                        $http.post('saveCopyData', formdata).success(function (response) {
                                    $scope.savecopyres = response;
                                    alert($scope.savecopyres.msg);
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
                font-size: 13px;
                border: 1px solid #333;
                margin-bottom:0px
            }
            .modal{
                width:80%;
                height: 90%;
                left:400px;
                top:4%
            }
            .modal-body{
                max-height: 500px;
            }
            .modal-header{
                height:9%;
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

        <div class="panel panel-info" style='width:80%;margin-left: 8%'>
            <div class="panel-heading">BOM Entry</div>
            <div class="panel-body">
                <form  class="form-horizontal" name="myform"  nonvalidate>  
                    <div class="row">
                        <div class="col-md-4" >
                            <div class="form-group">
                                <label class="control-label col-sm-2">Select Season</label>
                                <div data-ng-init="populateSeasList()"  class=" input-group col-sm-5" >
                                    <select id="seas_code" ng-model="seas_code" name="seas_code" required ng-change="getSeasonDesc()" ng-blur="getSerial(seas_code)" class="form-control" >
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
                        <div class="col-md-6" >
                            <div class="form-group">
                                <label class="control-label col-sm-5">Serial</label>
                                <div class="input-group col-sm-5">
                                    <select ng-model="serial" name="serial" id="serial" class="form-control" ng-init="" ng-blur="getColour(seas_code, serial)" required >
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
                                    <select ng-model="colour" name="colour" id="colour" class="form-control" required ng-options="c.COLOUR_CODE for c in colourlist track by c.COLOUR_CODE"  ng-blur="getdata()" ng-disabled="forallDisable">
                                        <option value="">--Please Select--</option>
                                    </select>
                                    <span ng-show="myform.colour.$touched && myform.colour.$error.required" style="color: red">Required.</span>
                                    {{colour.COLOUR_DESC}}
                                </div>
                            </div>
                        </div>
                    </div>

                    <fieldset title="Other Details">
                        <legend>Details</legend>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Buyer Code</label>
                                    <div class="input-group col-sm-4">
                                        <input class="form-control" id="buyer_code" type="text"  ng-model="buyer_code" ng-value="bomdetails.buyer_code" readonly>

                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Order Quantity</label>
                                    <div class="input-group col-sm-3"> 
                                        <input type="text"  id="order_qty" ng-model="order_qty" ng-value="bomdetails.order_qty"  class="form-control" readonly/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Buyer Style</label>
                                    <div class="input-group col-sm-4"> 
                                        <input type="text"  id="b_style" data-ng-model="b_style" ng-value="bomdetails.b_style" class="form-control" readonly/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Garment Description</label>
                                    <div class="input-group col-sm-6"> 
                                        <input type="text"  id="gar_desc" ng-model="gar_desc" data-ng-value="bomdetails.gar_desc" class="form-control" readonly/>
                                    </div>
                                </div>
                            </div>

                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Style No.</label>
                                    <div class="input-group col-sm-5">
                                        <input class="form-control" id="style_no" type="text" readonly ng-model="style_no" ng-value="bomdetails.style_no">
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Main fabric</label>
                                    <div class="input-group col-sm-5"> 
                                        <input type="text"  id="main_fab" ng-model="main_fab" readonly ng-value="bomdetails.main_fab"  class="form-control"/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Delivery Date</label>
                                    <div class="input-group col-sm-5"> 
                                        <input type="date"  id="delv_date" name="delv_date"  readonly ng-model="delv_date" ng-value="bomdetails.delv_date"   class="form-control"/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Wov/Hos/Swe</label>
                                    <div class="input-group col-sm-3"> 
                                        <input type="text"  id="wov_hos" name="wov_hos" ng-model="wov_hos" ng-value="bomdetails.wov_hos"  class="form-control" readonly/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6">
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Price</label>
                                    <div class="input-group col-sm-5"> 
                                        <input type="text" name="price" id="price" ng-model="price" ng-value="bomdetails.price" class="form-control" readonly/>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Print</label>
                                    <div class="input-group col-sm-3"> 
                                        <input type="text"  id="print" ng-model="print"  ng-value="bomdetails.print"  class="form-control" readonly/>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="row">
                            <div class="col-md-6" >
                                <div class="form-group">
                                    <label class="control-label col-sm-1">Colour Way</label>
                                    <div class=" input-group col-sm-4"> 
                                        <input type="text" name="colour_way" id="colour_way" ng-model="colour_way" ng-value="bomdetails.colour_way" class="form-control" readonly/>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </fieldset></br><br/>
                    <div class="row">
                        <div class="col-md-6" >
                            <div class="form-group">
                                <label class="control-label col-sm-1">Select Fabric Entry</label>
                                <div class="input-group col-sm-5">
                                    <select ng-model="part" name="part" id="part" class="form-control" required>
                                        <option value="">--Select--</option>
                                        <option value="1">Part 1</option>
                                        <option value="2">Part 2</option>
                                        <option value="3">Part 3</option> 
                                        <option value="4">Part 4</option>
                                    </select>
                                    <span ng-show="myform.fabentry.$invalid && myform.fabentry.$error.required" style="color: red">Required.</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6" >
                            <div class="form-group">
                                <label class="control-label col-sm-1">Select Options</label>
                                <div class="input-group col-sm-5">
                                    <select  ng-model="options" ng-change="bomadd(options)" name="options" id="options" class="form-control" required>
                                        <option value="">--Select--</option>
                                        <option value="add">Add New</option>
                                        <option value="edit">Edit Old</option>
                                        <option value="view">View</option> 
                                        <option value="copy">Copy</option> 
                                    </select>
                                    <span ng-show="myform.options.$invalid && myform.options.$error.required" style="color: red">Required.</span>
                                </div>
                            </div>
                        </div>
                    </div>
                    <input type="button" id="btnSubmit" value="Submit" />
            </div>
        </div>
    </form>
    <div modal="showModal" close="cancel()">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h5 class="modal-title">Fabric Entry PART  - ${part} <input type="text" id="part" value="${part}" ng-model="part" style="border: 0px;"></h5>
        </div>
        <div class="modal-body">

            <form  class="form-horizontal" name="myform" ng-submit="submit()" nonvalidate>  
                <div class="row">
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="control-label col-sm-1">Season Code</label>
                            <div class="input-group col-sm-2">
                                <input class="form-control" id="seas_code" type="text" value="${seas_code}" ng-model="seas_code" ng-value="${seas_code}" readonly>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <div class="form-group">
                            <label class="control-label col-sm-1">Grey Code</label>
                            <div class="input-group col-sm-4">
                                {{fabric.grey_code}}
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="control-label col-sm-1">Grey Desc</label>
                            {{fabric.grey_desc}}
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="control-label col-sm-1">Code</label>
                            <div class="input-group col-sm-6">
                                <input class="form-control" id="code" type="text"  ng-model="code" ng-value="codelists" ng-blur="checkFabCode()" >
                                <div class="input-group-btn">
                                    <select ng-model="codelists" id="codelists" name="codelists" required class="form-control" ng-change="getFabGreyCode(codelists)" ng-blur="checkFabCode()">
                                        <option value="" >--Select Colour--</option>
                                        <option data-ng-repeat="code in codelist" value="{{code.FAB_CODE}}">{{code.FAB_DESC}} / {{code.MFAB_DESC}} / {{code.FAB_CODE}}</option>
                                    </select>
                                    {{codelists.FAB_DESC}}
                                </div>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-6"> 
                        <div class="form-group">
                            <label class="control-label col-sm-1">Colour</label>
                            <div class="input-group col-sm-5" >
                                <select ng-model="colour_code" id="colour_code" name="colour_code" required class="form-control" ng-click="getBaseCodedata()" ng-blur="checkitemcode()" ng-disabled="colourdisable">
                                    <option value="" >--Select Colour--</option>
                                    <option data-ng-repeat="color in colours" value="{{color.COLOUR_CODE}}">{{color.COLOUR_DESC}}</option>
                                </select>
                                {{colour_code.COLOUR_DESC}}
                                <span ng-show="myform.colour_code.$touched && myform.colour_code.$error.required" style="color: red">Required.</span>
                            </div>

                        </div>
                    </div>
                </div>
                <div class="row" id="basecode">
                    <div class="col-sm-6"> 
                        <div class="form-group">
                            <label class="control-label col-sm-1">Base Code</label>
                            <div class=" col-sm-5">
                                <select ng-model="base_code" id="base_code" name="base_code" required class="form-control"  >
                                    <option value="" >--Select Colour--</option>
                                    <option data-ng-repeat="bcode in basecodelist" value="{{bcode.FAB_CODE}}">{{bcode.FAB_DESC}} / {{bcode.MFAB_DESC}} / {{bcode.FAB_CODE}}</option>
                                </select>
                                {{base_code.FAB_DESC}}
                            </div>

                        </div>
                    </div>
                    <div class="col-sm-6"> 
                        <div class="form-group">
                            <label class="control-label col-sm-1">Base Colour</label>
                            <div class="col-sm-6"> 
                                <select ng-model="base_colour" id="base_colour" name="base_colour" required class="form-control" >
                                    <option value="" >--Select Colour--</option>
                                    <option data-ng-repeat="color in colours" value="{{color.COLOUR_CODE}}">{{color.COLOUR_DESC}}</option>
                                </select>
                                {{base_colour.COLOUR_DESC}}
                                <span ng-show="myform.colour_code.$touched && myform.colour_code.$error.required" style="color: red">Required.</span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row" id="qtydiv">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="control-label col-sm-1">Quantity</label>
                            <div class="input-group col-sm-4">
                                <input class="form-control" id="qty" type="number" min="1" ng-model="qty"  ng-blur="calcAvg(qty)" ng-disabled="qtydisable">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="control-label col-sm-1">Average</label>
                            <div class="input-group col-sm-4">
                                <input class="form-control" id="avg" type="text"  ng-model="avg"  ng-value="avgvalue" ng-disabled="avgdone" >
                            </div>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="control-label col-sm-1">Width</label>
                            <div class="input-group col-sm-4">
                                <input class="form-control" id="width" type="text"  ng-model="width"  ng-blur="getwidth(width)">
                            </div>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-6">
                        <div class="form-group">
                            <label class="control-label col-sm-1">Catalog</label>
                            <div class="input-group col-sm-5">
                                <input class="form-control" id="catalog" type="text"  ng-model="catalog" ng-value="cat.CAT_NAME" ng-blur="getcatalog(catalog)">
                                <div class="input-group-btn">
                                    <select  id="catalog" data-ng-model="catalog" class="form-control"  >
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
                <div class="row">
                    <div class="col-md-2" ></div>
                    <div class="col-md-10" >
                        <div id="set">
                            <fieldset>
                                <label class="radio-inline">
                                    <input type="radio" name="setradio" ng-click="checkapproved(setradio)" required ng-model="setradio" value="Y" >Approved
                                </label>
                                <label class="radio-inline">
                                    <input type="radio"  name="setradio" ng-click="checkapproved(setradio)" required ng-model="setradio" value="N" checked >Not Approved
                                </label><br/>

                                <label ng-model="result" class="control-label col-sm-1" ><b>{{result}}</b></label>
                            </fieldset>
                            <span ng-show="myform.setradio.$invalid && myform.setradio.$error.required" style="color: red">Required.</span>
                        </div>
                    </div>
                </div>
                <div class="row">
                    <div class="col-md-12" >
                        <table class="table table-bordered table-condensed  table-sm "  style="width:60;font-size: 10px;line-height:10px;padding: 0px">
                            <thead >
                                <tr>
                                    <th class="col-sm-1" >Serial</th>
                                    <th class="col-sm-1" >Colour</th>
                                    <th class="col-sm-1" >Item Code</th>
                                    <th class="col-sm-1" >Size</th>
                                    <th class="col-sm-1" >Catalog</th>
                                    <th class="col-sm-1" >Average</th>
                                    <th class="col-sm-1" >UOM</th>
                                </tr>
                            </thead>
                            <tbody >
                                <tr ng-repeat="bom in bomdata">
                                    <td>{{bom.serial}}</td>
                                    <td>{{bom.colour}}</td>
                                    <td>{{bom.item_code}}</td>
                                    <td>{{bom.size}}</td>
                                    <td>{{bom.CATALOG}}</td>
                                    <td>{{bom.aveg}}</td>
                                    <td>{{bom.uom}}</td>

                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="modal-footer">
                    <button   type="button" class="btn btn-success" ng-click="Save()" ng-disabled="savedisable" >Save</button>
                    <button type="button" class="btn" ng-click="cancel()">Cancel</button>
                </div>
        </div>
    </div>
    <div modal="showModalforView" close="cancel()">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" aria-hidden="true">&times;</button>
            <h5>Fabric View  - ${part} <input type="text"  id="part" value="${part}" ng-model="part" style="border: 0px;background-color: #d9edf7; "></h5>
        </div>
        <div class="modal-body">
            <div class="row">
                <div class="col-md-12" >
                    <div class="table-responsive">          
                        <table class="table table-bordered table-condensed  table-sm "  style="width:60;font-size: 10px;line-height:10px;padding: 0px">
                            <thead>
                                <tr>
                                    <th class="col-sm-1" >Serial</th>
                                    <th class="col-sm-1" >Colour</th>
                                    <th class="col-sm-1" >Item Code</th>
                                    <th class="col-sm-1" >Size</th>
                                    <th class="col-sm-1" >Catalog</th>
                                    <th class="col-sm-1" >Average</th>
                                    <th class="col-sm-1" >UOM</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ng-repeat="bom in bomdata">
                                    <td>{{bom.serial}}</td>
                                    <td>{{bom.colour}}</td>
                                    <td>{{bom.item_code}}</td>
                                    <td>{{bom.size}}</td>
                                    <td>{{bom.CATALOG}}</td>
                                    <td>{{bom.aveg}}</td>
                                    <td>{{bom.uom}}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">

            <button type="button" class="btn" ng-click="cancelViewModal()">Cancel</button>
        </div>
    </div>
    <div modal="showModalforCopy" close="cancelCopyModal()">
        <div class="modal-header">
            <button type="button" class="close" data-dismiss="modal" ng-click="cancelCopyModal()" aria-hidden="true">&times;</button>
            <h5 class="modal-title">Fabric Copy  - ${part} <input type="text"  id="part" value="${part}" ng-model="part" style="border: 0px;background-color: #d9edf7; "></h5>
        </div>
        <div class="modal-body">
            <div class="row">
                <div class="col-md-5" >
                    <div class="form-group">
                        <label class="control-label col-sm-4">Select Season</label>
                        <div data-ng-init="populateSeasList()"  class=" input-group col-sm-5" >
                            <select id="seas_code" ng-model="seas_code" name="seas_code" required ng-change="getSeasonDesc()" ng-blur="getSerial(seas_code)" class="form-control" >
                                <option value="" >Select Season</option>
                                <option data-ng-repeat="s in season" value="{{s.seas_code}}">{{s.seas_code}}</option>
                            </select> 
                            <span ng-show="myform.seas_code.$invalid && myform.seas_code.$error.required" style="color: red">Required.</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-3" >
                    <div class="form-group">
                        {{data.seas_desc}}
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-5" >
                    <div class="form-group">
                        <label class="control-label col-sm-3">Serial</label>
                        <div class="input-group col-sm-5">
                            <select ng-model="serial" name="serial" id="serial" class="form-control" ng-init="" ng-blur="getColour(seas_code, serial)" required >
                                <option ng-repeat="ser in seriallist" value="{{ser.SERIAL}}">{{ser.SERIAL}}</option>
                            </select>
                            <span ng-show="myform.serial.$touched && myform.serial.$error.required" style="color: red">Required.</span>
                        </div>
                    </div>
                </div>
                <div class="col-md-4" >
                    <div class="form-group">
                        <label class="control-label col-sm-3">Colour</label>
                        <div class="input-group col-sm-6">
                            <select ng-model="colour" name="colour" id="colour" class="form-control" required ng-options="c.COLOUR_CODE for c in colourlist track by c.COLOUR_CODE"  ng-blur="getcopydata()" >
                                <option value="">--Please Select--</option>
                            </select>
                            <span ng-show="myform.colour.$touched && myform.colour.$error.required" style="color: red">Required.</span>
                            {{colour.COLOUR_DESC}}
                        </div>
                    </div>
                </div>
                <div class="col-md-3" >
                    <div class="form-group">
                        <label class="control-label col-sm-5">Style No</label>
                        <div class="input-group col-sm-1">
                            {{bomcopydata.style_no}}
                        </div>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12" >
                    Select the item to copy
                </div></div>
            <div class="row">
                <div class="col-md-12" >
                    <div class="table-responsive">          
                        <table class="table table-bordered table-condensed  table-sm "  style="width:60;font-size: 10px;line-height:10px;padding: 0px">
                            <thead >
                                <tr>
                                    <th class="col-sm-1" >Select</th>
                                    <th class="col-sm-1" >Serial</th>
                                    <th class="col-sm-1" >Colour</th>
                                    <th class="col-sm-1" >Item Code</th>
                                    <th class="col-sm-1" >Size</th>
                                    <th class="col-sm-1" >Average</th>
                                    <th class="col-sm-1" >Part</th>
                                    <th class="col-sm-1" >Base Code</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ng-repeat="bom in bomcopydata.bomdata">
                                    <td><input type="checkbox" name="selitem" ng-model="bom.selitem" /></td>
                                    <td>{{bom.serial}}</td>
                                    <td>{{bom.colour}}</td>
                                    <td>{{bom.item_code}}</td>
                                    <td>{{bom.size}}</td>
                                    <td>{{bom.aveg}}</td>
                                    <td>{{bom.part}}</td>
                                    <td>{{bom.base_code}}</td>
                                </tr>
                            </tbody>
                        </table>

                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-12" >
                    Select the target control numbers
                </div>
            </div>
            <div class="row">
                <div class="col-md-6" >
                    <div class="table-responsive">          
                        <table class="table table-bordered table-condensed  table-sm "  style="width:60;font-size: 10px;line-height:10px;padding: 0px">
                            <thead>
                                <tr>
                                    <th class="col-sm-1" >Select</th>
                                    <th class="col-sm-1" >Serial</th>
                                    <th class="col-sm-1" >Colour</th>
                                    <th class="col-sm-1" >Style No</th>
                                    <th class="col-sm-1" >Colour Desc</th>
                                </tr>
                            </thead>
                            <tbody>
                                <tr ng-repeat="bom in bomcopydata.seriallist">
                                    <td><input type="checkbox" name="selcontrol" ng-model="bom.selcontrol" ng-required="bom.selitem" ng-click="setItemcolour(bom.selcontrol)"/></td>
                                    <td>{{bom.serial}}</td>
                                    <td>{{bom.colour}}</td>
                                    <td>{{bom.style_no}}</td>
                                    <td>{{bom.colour_desc}}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="col-md-6" id="selItemColorArray">
                    Item Colour
                    <div class="table-responsive">          
                        <table class="table table-bordered table-condensed  table-sm "  style="width:60;font-size: 10px;line-height:10px;padding: 0px">
                            <thead>
                                <tr>
                                    <th class="col-sm-1" >Serial</th>
                                    <th class="col-sm-1" >Colour</th>
                                    <th class="col-sm-1" >Item Code</th>
                                    <th class="col-sm-1" >Base Code</th>
                                </tr>
                            </thead>
                            <tbody >
                                <tr ng-repeat="s in selItemColorArray" >
                                    <td>{{s.serial}}</td>
                                    <td>{{s.colour}}</td>
                                    <td><div class="input-group col-sm-4">{{s.item_code}} <div class="input-group-btn">
                                                <select ng-model="itemcolour_code" id="itemcolour_code" name="itemcolour_code"  class="form-control" ng-change="changeItemcolour(s,s.item_code,itemcolour_code)">
                                    <option data-ng-repeat="color in colourlistall" value="{{color.COLOUR_CODE}}">{{color.COLOUR_DESC}}</option>
                                        </select></div></div></td>
                                    <td>{{s.base_code}}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    
                </div>
                <div class="col-md-6" id="selBaseColorArray">
                    Base Colour
                    <div class="table-responsive">          
                        <table class="table table-bordered table-condensed  table-sm "  style="width:60;font-size: 10px;line-height:10px;padding: 0px">
                            <thead>
                                <tr>
                                    <th class="col-sm-1" >Serial</th>
                                    <th class="col-sm-1" >Colour</th>
                                    <th class="col-sm-1" >Base Code</th>
                                    <th class="col-sm-1" >Base Code</th>
                                    <th class="col-sm-1" >Item Code</th>
                                </tr>
                            </thead>
                            <tbody >
                                <tr ng-repeat="s in selBaseColorArray" >
                                    <td>{{s.serial}}</td>
                                    <td>{{s.colour}}</td>
                                    <td><div class="input-group col-sm-4">{{s.base_code}} <div class="input-group-btn">
                                                <select ng-model="basecolour_code" id="basecolour_code" name="basecolour_code"  class="form-control" ng-change="changeBasecolour(s,s.base_code,basecolour_code)">
                                    <option data-ng-repeat="color in colourlistall" value="{{color.COLOUR_CODE}}">{{color.COLOUR_DESC}}</option>
                                        </select></div></div></td>
                                         <td>{{s.obase_code}}</td>
                                    <td>{{s.item_code}}</td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
       <%--     <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="control-label col-sm-4">Change Item Colour</label>
                        <fieldset>
                            <label class="radio-inline">
                                <input type="radio" name="colourradio" ng-click="setItemcolour(colourradio)" required ng-model="colourradio" value="Y" >Yes
                            </label>
                            <label class="radio-inline">
                                <input type="radio"  name="colourradio" ng-click="setItemcolour(colourradio)" required ng-model="colourradio" value="N" checked >No
                            </label>
                        </fieldset>
                    </div>
                </div>
            </div>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="control-label col-sm-4">Change Base Colour</label>
                        <fieldset>
                            <label class="radio-inline">
                                <input type="radio" name="basecolourradio" ng-click="setBaseColour(basecolourradio)" required ng-model="basecolourradio" value="Y" >Yes
                            </label>
                            <label class="radio-inline">
                                <input type="radio"  name="basecolourradio" ng-click="setBaseColour(basecolourradio)" required ng-model="basecolourradio" value="N" checked >No
                            </label>
                        </fieldset>
                    </div>
                </div>
            </div>--%>
            <div class="row">
                <div class="col-md-6">
                    <div class="form-group">
                        <label class="control-label col-sm-4">Copy As Approved</label>
                        <fieldset>
                            <label class="radio-inline">
                                <input type="radio" name="copyappradio" ng-click="checkapproved(setradio)" required ng-model="copyappradio" value="Y" >Yes
                            </label>
                            <label class="radio-inline">
                                <input type="radio"  name="copyappradio" ng-click="checkapproved(setradio)" required ng-model="copyappradio" value="N" checked >No
                            </label>
                        </fieldset>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal-footer">
            <button type="button" class="btn" ng-click="saveCopyData()" ng-disabled="copydisable">Copy</button>
            <button type="button" class="btn" ng-click="cancelCopyModal()">Cancel</button>
        </div>
    </div>
</body>
</html>
