<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
    "http://www.w3.org/TR/html4/loose.dtd">

<html ng-app>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home Pag e</title>
        <script src="http://ajax.googleapis.com/ajax/libs/angularjs/1.4.8/angular.min.js"></script>  
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
        <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.2.1/jquery.min.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

    </head>
    <body ng-app="myApp">

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
                            <li><a href="CancelQuantity">Cancel Quantity </a></li>
                            <li><a href="InvoiceCancel">Invoice Cancel</a></li>
                            <li><a href="OrderModification">Order Modification</a></li>
                            <li><a href="SizePriceEntry">Size Price Entry</a></li>
                            <li><a href="CatalogEntry">Catalog Entry</a></li>
                            <li><a href="CatalogView">Catalog view</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Entry <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="NormalOrderEntry">Normal Order Entry</a></li>
                            <li><a href="POEntry">PO Addition</a></li>
                            <li><a href="#">Showroom Order Entry</a></li>
                            <li><a href="#">Sample Order Entry</a></li>
                            <li><a href="FabRateEntry">Fab Rate Entry</a></li>
                            <li><a href="InvoiceEntry">Invoice Entry</a></li>
                            <li><a href="BOMEntry">BOM Entry</a></li>
                             <li><a href="BOM4">BOM Part IV Multiple Style Entry</a></li>
                            <li><a href="POApprovedModule">PO Approved Module</a></li>
                            <li><a href="BOMApprovedModule">BOM Approved Module</a></li>
                        </ul>
                    </li>
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Printing <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="OGRSPrinting">OGRSPrinting</a></li>
                            <li><a href="POEntry">PO Addition</a></li>

                        </ul>
                    </li>
                    <li class="dropdown">
                        <a class="dropdown-toggle" data-toggle="dropdown" href="#">Query <span class="caret"></span></a>
                        <ul class="dropdown-menu">
                            <li><a href="BomPoQuery">BOM/PO Query</a></li>
                        </ul>
                    </li>
                </ul>
                <ul class="nav navbar-nav navbar-right">

                    <li><a href="#"><span class="glyphicon glyphicon-log-in"></span> Login</a></li>
                </ul>
            </div>
        </div>
    </nav>  
    <div class="container" style="">
        <h3>Client Module</h3>

    </div>
</body>
</html>
