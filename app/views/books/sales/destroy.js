$("#<%= @book.id %>_sales").html("<%=j render partial: "books/sales" %>");
$("#flash_notice").html("<%=j render partial: "books/notices/saledestroy" %>");