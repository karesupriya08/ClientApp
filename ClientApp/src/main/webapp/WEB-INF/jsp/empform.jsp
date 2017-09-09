<%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>    
<head>
    <script src="https://code.jquery.com/jquery-1.12.4.js" type="text/javascript"></script>  
     <script>  
   function doAjaxPost() {  
      
     
    var name = $('#country').val();  
     
    $.ajax({
                type: "GET",
                url: "getstates",
              //  dataType: "application/json",
                headers: {"Accept": "application/json"},
              //  data : {"country":  name}, 
                 success: function(data){
                    
                     $.each(data, function(index, value) {
        $('#state').append($('<option>').text(value).val(index));
    });
                },error: function() {alert('eerrrr');}
            });
   }
  </script>  
</head>
<body>
<h3>Normal Order Entry</h3>  
<form:form method="post" action="save">    
    <table > 
        <tr>
            <td><form:label path = "season">Season</form:label></td>
                <td>
                <form:select path="season" >
                    <form:option value="0" label="Select" />
                    <form:options items="${seasonList}" itemValue="seas_code" itemLabel="seas_code" />
                </form:select>
            </td>
        </tr>
        <tr>    
            <td><form:label path = "buyer_code">Buyer Code</form:label></td>
            <td><form:input path="buyer_code" /></td>  
        </tr>   
        <tr>    
            <td><form:label path = "order_status">Order Status</form:label></td>
            <td><form:input path="order_status" /></td>  
        </tr> 
        <tr>    
            <td><form:label path = "order_date">Order Date</form:label></td>
            <td><form:input type="date" path="order_date"  /></td>  
        </tr>  
        <tr>    
            <td><form:label path = "b_style">Buyer Style</form:label></td>
            <td><form:input path="b_style" /></td>  
        </tr> 
        <tr>   
            <td><form:label path = "quota_seg">Quota Seg.</form:label></td>
            <td><form:input path="quota_seg" /></td>  
        </tr>
        <tr>   
            <td><form:label path = "quota_cat">Quota Cat.</form:label></td>
            <td><form:input path="quota_cat" /></td>  
        </tr>
        <tr>   
            <td><form:label path = "garment_desc">Garment Description</form:label></td>
            <td><form:input path="garment_desc" /></td>  
        </tr>
        <tr>   
            <td><form:label path = "int_ord">Internal Order</form:label></td>
            <td><form:input path="int_ord" /></td>  
        </tr>
        <tr>
            <td>   <form:select path="country" onchange="doAjaxPost();">
               <form:option value="NONE" label="Select"/>
               <form:options items="${countryList}" />
            </form:select>    </td>
             <td>   <form:select path="state" >
               
            </form:select>   
               
                
             </td>
           
        </tr>
                   <tr>    
            <td> </td>    
            <td><input type="submit" value="Add" /></td>    
        </tr>    
    </table>    
</form:form>    
</body>