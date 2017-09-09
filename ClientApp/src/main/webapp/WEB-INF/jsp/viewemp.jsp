 <%@ taglib uri="http://www.springframework.org/tags/form" prefix="form"%>    
   <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>    
   <html>
       <head>
           <script>
               window.onload = function () {
                   alert("hi");
    window.print();
};
           </script>
           <style>
        
           </style>
       </head>
       <body onload="window.print()">
           Bpm/Po Details
${b_style}
<c:if test="${not empty stylenolist}">

		<ul>
			<c:forEach var="listValue" items="${stylenolist}">
				<li>${listValue.SIZE_TYPE}</li>
                                <li>${listValue.SIZE_QTY}</li>
			</c:forEach>
		</ul>

	</c:if>
  </body>