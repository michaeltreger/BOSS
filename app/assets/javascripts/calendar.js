$(document).ready(function() {

   var $calendar = $('#calendar');
   var id = 999999999;
   var $events;
   
   $('#submit_calendar').bind('click', submit);
   
   function submit() {
      finalizedEvents = $calendar.weekCalendar("serializeEvents");
      finalizedEvents.map(convertTimesOut);
      
      json = JSON.stringify(finalizedEvents);
      //alert(json);
      $.ajax({
        type: "PUT",
        url: window.location.pathname+".json",
        data: {"calendar_updates": json},
        dataType: "json",
        success: function(data, textStatus, XMLHttpRequest){
           //alert("Succeeded");
        },
        error: function(data, textStatus, XMLHttpRequest){
           //eval('('+responseText+')');
           //alert(data);
        }
      });
   }
   
   getEventData();
   
   function getEventData() {   
      $.ajax({
         type: "GET",
         url: window.location.pathname+".json",
         dataType: "json",
         success: function(data) {
            data.map(convertTimesIn);
            $events = data;
            startCalendar();
         }
      });
   }
   
   function convertTimesIn(event) {
      timezone_offset = new Date().getTimezoneOffset();
      event.start_time = Date.parse(event.start_time).add(-timezone_offset).minutes();//.add(-2).hours();
      event.end_time = Date.parse(event.end_time).add(-timezone_offset).minutes();//.add(-2).hours();
   }
   
   function convertTimesOut(event) {
      //event.start_time = event.start_time.add(2).hours();
      //event.end_time = event.end_time.add(2).hours();
      
      alert(event.start_time);
   }
   
   function startCalendar() {
     $calendar.weekCalendar({
        displayOddEven:true,
        timeslotsPerHour : 2,
        allowCalEventOverlap : false,
        overlapEventsSeparate: true,
        firstDayOfWeek : 0,
        businessHours :{start_time: 6, end_time: 24, limitDisplay: true },
        daysToShow : 7,
        height : function($calendar) {
           return 760;//$(window).height() - $("h1").outerHeight() - 1;
        },
        eventRender : function(calEvent, $event) {
           if (calEvent.entry_type=== "rather_not") {
              $event.css("backgroundColor", "#c6c");
              $event.find(".wc-time").css({
                 "backgroundColor" : "#a4a",
                 "border" : "1px solid #949"
              });
           } else if (calEvent.entry_type=== "obligation") {
              $event.css("backgroundColor", "#3c6");
              $event.find(".wc-time").css({
                 "backgroundColor" : "#1a4",
                 "border" : "1px solid #093"
              });
           } else if (calEvent.entry_type=== "class") {
              $event.css("backgroundColor", "#f23");
              $event.find(".wc-time").css({
                 "backgroundColor" : "#c12",
                 "border" : "1px solid #b12"
              });
           } else if (calEvent.entry_type=== "closed") {
              $event.css("backgroundColor", "#aaa");
              $event.find(".wc-time").css({
                 "backgroundColor" : "#999",
                 "border" : "1px solid #888"
              });
           }
        },
        draggable : function(calEvent, $event) {
           return calEvent.readOnly != true;
        },
        resizable : function(calEvent, $event) {
           return calEvent.readOnly != true;
        },
        eventNew : function(calEvent, $event) {
           var $dialogContent = $("#event_edit_container");
           resetForm($dialogContent);
           var startField = $dialogContent.find("select[name='start']").val(calEvent.start_time);
           var endField = $dialogContent.find("select[name='end']").val(calEvent.end_time);
           var entry_typeField = $dialogContent.find("select[name='entry_type']").val(calEvent.entry_type);
           var descriptionField = $dialogContent.find("textarea[name='description']");

           setDescriptionVisibility()

           $dialogContent.dialog({
              modal: true,
              title: "New Calendar Event",
              close: function() {
                 $dialogContent.dialog("destroy");
                 $dialogContent.hide();
                 $('#calendar').weekCalendar("removeUnsavedEvents");
              },
              buttons: {
                 save : function() {
                    calEvent.id = id;
                    id++;
                    calEvent.start_time = new Date(startField.val());
                    calEvent.end_time = new Date(endField.val());
                    calEvent.entry_type = entry_typeField.val();
                    calEvent.description = descriptionField.val();

                    $calendar.weekCalendar("removeUnsavedEvents");
                    $calendar.weekCalendar("updateEvent", calEvent);
                    $dialogContent.dialog("close");
                 },
                 cancel : function() {
                    $dialogContent.dialog("close");
                 }
              }
           }).show();

           $dialogContent.find(".date_holder").text($calendar.weekCalendar("formatDate", calEvent.start_time));
           setupStartAndEndTimeFields(startField, endField, calEvent, $calendar.weekCalendar("getTimeslotTimes", calEvent.start_time));

        },
        eventDrop : function(calEvent, $event) {
           $calendar.weekCalendar("updateEvent", calEvent);
        },
        eventResize : function(calEvent, $event) {
           $calendar.weekCalendar("updateEvent", calEvent);
        },
        eventClick : function(calEvent, $event) {

           if (calEvent.readOnly) {
              return;
           }

           var $dialogContent = $("#event_edit_container");
           resetForm($dialogContent);
           var startField = $dialogContent.find("select[name='start']").val(calEvent.start_time);
           var endField = $dialogContent.find("select[name='end']").val(calEvent.end_time);
           var entry_typeField = $dialogContent.find("select[name='entry_type']").val(calEvent.entry_type);
           var descriptionField = $dialogContent.find("textarea[name='description']").val(calEvent.description);

           setDescriptionVisibility();

           $dialogContent.dialog({
              modal: true,
              title: "Edit - " + calEvent.entry_type,
              close: function() {
                 $dialogContent.dialog("destroy");
                 $dialogContent.hide();
                 $('#calendar').weekCalendar("removeUnsavedEvents");
              },
              buttons: {
                 save : function() {

                    calEvent.start_time = new Date(startField.val());
                    calEvent.end_time = new Date(endField.val());
                    calEvent.entry_type= entry_typeField.val();
                    calEvent.description = descriptionField.val();

                    $calendar.weekCalendar("updateEvent", calEvent);
                    $dialogContent.dialog("close");
                 },
                 "delete" : function() {
                    $calendar.weekCalendar("removeEvent", calEvent.id);
                    $dialogContent.dialog("close");
                 },
                 cancel : function() {
                    $dialogContent.dialog("close");
                 }
              }
           }).show();

           var startField = $dialogContent.find("select[name='start']").val(calEvent.start_time);
           var endField = $dialogContent.find("select[name='end']").val(calEvent.end_time);
           $dialogContent.find(".date_holder").text($calendar.weekCalendar("formatDate", calEvent.start_time));
           setupStartAndEndTimeFields(startField, endField, calEvent, $calendar.weekCalendar("getTimeslotTimes", calEvent.start_time));
           $(window).resize().resize(); //fixes a bug in modal overlay size ??

        },
        eventMouseover : function(calEvent, $event) {
        },
        eventMouseout : function(calEvent, $event) {
        },
        noEvents : function() {

        },
        data : $events
     });
   }
   
   
   function resetForm($dialogContent) {
      $dialogContent.find("input").val("");
      $dialogContent.find("textarea").val("");
   }

   /*
    * Sets up the start and end time fields in the calendar event
    * form for editing based on the calendar event being edited
    */
   function setupStartAndEndTimeFields($startTimeField, $endTimeField, calEvent, timeslotTimes) {

      $startTimeField.empty();
      $endTimeField.empty();

      for (var i = 0; i < timeslotTimes.length; i++) {
         var startTime = timeslotTimes[i].start;
         var endTime = timeslotTimes[i].end;
         var startSelected = "";
         if (startTime.getTime() === calEvent.start_time.getTime()) {
            startSelected = "selected=\"selected\"";
         }
         var endSelected = "";
         if (endTime.getTime() === calEvent.end_time.getTime()) {
            endSelected = "selected=\"selected\"";
         }
         $startTimeField.append("<option value=\"" + startTime + "\" " + startSelected + ">" + timeslotTimes[i].startFormatted + "</option>");
         $endTimeField.append("<option value=\"" + endTime + "\" " + endSelected + ">" + timeslotTimes[i].endFormatted + "</option>");

         $timestampsOfOptions.start[timeslotTimes[i].startFormatted] = startTime.getTime();
         $timestampsOfOptions.end[timeslotTimes[i].endFormatted] = endTime.getTime();

      }
      $endTimeOptions = $endTimeField.find("option");
      $startTimeField.trigger("change");
   }

   var $endTimeField = $("select[name='end']");
   var $endTimeOptions = $endTimeField.find("option");
   var $timestampsOfOptions = {start:[],end:[]};

   //reduces the end time options to be only after the start time options.
   $("select[name='start']").change(function() {
      var startTime = $timestampsOfOptions.start[$(this).find(":selected").text()];
      var currentEndTime = $endTimeField.find("option:selected").val();
      $endTimeField.html(
            $endTimeOptions.filter(function() {
               return startTime < $timestampsOfOptions.end[$(this).text()];
            })
      );

      var endTimeSelected = false;
      $endTimeField.find("option").each(function() {
         if ($(this).val() === currentEndTime) {
            $(this).attr("selected", "selected");
            endTimeSelected = true;
            return false;
         }
      });

      if (!endTimeSelected) {
         //automatically select an end date 2 slots away.
         $endTimeField.find("option:eq(1)").attr("selected", "selected");
      }

   });

   function setDescriptionVisibility() {
      if ($("select[name='entry_type']").val() === "obligation") {
         document.getElementById("description").style.display='block';
      } else {
         $('#description > textarea').val("");
         document.getElementById("description").style.display='none';
      }
   }

   $("select[name='entry_type']").change(setDescriptionVisibility);

});
