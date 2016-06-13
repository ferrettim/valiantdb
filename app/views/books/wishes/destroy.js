$("#<%= @book.id %>_wishes").html("<%=j render partial: "books/wishes" %>");
$("#flash_notice").html("<%=j render partial: "books/notices/wishdestroy" %>");