$(document).ready(function() {

   var $calendar = $('#calendar');
   var id = 10;

   $calendar.weekCalendar({
      displayOddEven:true,
      timeslotsPerHour : 2,
      allowCalEventOverlap : false,
      overlapEventsSeparate: true,
      firstDayOfWeek : 0,
//      businessHours :{start: 8, end: 26, limitDisplay: true },
      businessHours :{start: 6, end: 24, limitDisplay: true },
      daysToShow : 7,
      switchDisplay: {'1 day': 1, '3 next days': 3, 'work week': 5, 'full week': 7},
      title: function(daysToShow) {
			return daysToShow == 1 ? '%date%' : '%start% - %end%';
      },
      height : function($calendar) {
         return 760;//$(window).height() - $("h1").outerHeight() - 1;
      },
      eventRender : function(calEvent, $event) {
         if (calEvent.type === "rather_not") {
            $event.css("backgroundColor", "#c6c");
            $event.find(".wc-time").css({
               "backgroundColor" : "#a4a",
               "border" : "1px solid #949"
            });
         } else if (calEvent.type === "obligation") {
            $event.css("backgroundColor", "#3c6");
            $event.find(".wc-time").css({
               "backgroundColor" : "#1a4",
               "border" : "1px solid #093"
            });
         } else if (calEvent.type === "class") {
            $event.css("backgroundColor", "#f23");
            $event.find(".wc-time").css({
               "backgroundColor" : "#c12",
               "border" : "1px solid #b12"
            });
         } else if (calEvent.type === "closed") {
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
         var startField = $dialogContent.find("select[name='start']").val(calEvent.start);
         var endField = $dialogContent.find("select[name='end']").val(calEvent.end);
         var typeField = $dialogContent.find("select[name='type']").val(calEvent.type);
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
                  calEvent.start = new Date(startField.val());
                  calEvent.end = new Date(endField.val());
                  calEvent.type = typeField.val();
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

         $dialogContent.find(".date_holder").text($calendar.weekCalendar("formatDate", calEvent.start));
         setupStartAndEndTimeFields(startField, endField, calEvent, $calendar.weekCalendar("getTimeslotTimes", calEvent.start));

      },
      eventDrop : function(calEvent, $event) {
        
      },
      eventResize : function(calEvent, $event) {
      },
      eventClick : function(calEvent, $event) {

         if (calEvent.readOnly) {
            return;
         }

         var $dialogContent = $("#event_edit_container");
         resetForm($dialogContent);
         var startField = $dialogContent.find("select[name='start']").val(calEvent.start);
         var endField = $dialogContent.find("select[name='end']").val(calEvent.end);
         var typeField = $dialogContent.find("select[name='type']").val(calEvent.type);
         var descriptionField = $dialogContent.find("textarea[name='description']").val(calEvent.description);

         setDescriptionVisibility();

         $dialogContent.dialog({
            modal: true,
            title: "Edit - " + calEvent.type,
            close: function() {
               $dialogContent.dialog("destroy");
               $dialogContent.hide();
               $('#calendar').weekCalendar("removeUnsavedEvents");
            },
            buttons: {
               save : function() {

                  calEvent.start = new Date(startField.val());
                  calEvent.end = new Date(endField.val());
                  calEvent.type = typeField.val();
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

         var startField = $dialogContent.find("select[name='start']").val(calEvent.start);
         var endField = $dialogContent.find("select[name='end']").val(calEvent.end);
         $dialogContent.find(".date_holder").text($calendar.weekCalendar("formatDate", calEvent.start));
         setupStartAndEndTimeFields(startField, endField, calEvent, $calendar.weekCalendar("getTimeslotTimes", calEvent.start));
         $(window).resize().resize(); //fixes a bug in modal overlay size ??

      },
      eventMouseover : function(calEvent, $event) {
      },
      eventMouseout : function(calEvent, $event) {
      },
      noEvents : function() {

      },
      data : function(start, end, callback) {
         callback(getEventData());
      }
   });

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
         if (startTime.getTime() === calEvent.start.getTime()) {
            startSelected = "selected=\"selected\"";
         }
         var endSelected = "";
         if (endTime.getTime() === calEvent.end.getTime()) {
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
      if ($("select[name='type']").val() === "obligation") {
         document.getElementById("description").style.display='block';
      } else {
         $('#description > textarea').val("");
         document.getElementById("description").style.display='none';
      }
   }

   $("select[name='type']").change(setDescriptionVisibility);

   function getEventData() {
      var year = new Date().getFullYear();
      var month = new Date().getMonth();
      var day = new Date().getDate();

      events = [
        {
           "id":1,
           "start": new Date(year, month, day, 10),
           "end": new Date(year, month, day, 13, 30),
           "type":"prefer"
        },
        {
           "id":2,
           "start": new Date(year, month, day, 14),
           "end": new Date(year, month, day, 16, 45),
           "type":"class"
        },
        {
           "id":3,
           "start": new Date(year, month, day + 1, 17),
           "end": new Date(year, month, day + 1, 19, 45),
           "type":"class"
        },
        {
           "id":4,
           "start": new Date(year, month, day - 1, 8),
           "end": new Date(year, month, day - 1, 14, 30),
           "type":"obligation"
        },
        {
           "id":5,
           "start": new Date(year, month, day + 1, 11),
           "end": new Date(year, month, day + 1, 15),
           "type":"prefer"
        },
        {
           "id":6,
           "start": new Date(year, month, day + 2, 18),
           "end": new Date(year, month, day + 3, 2),
           "type":"rather_not"
        },
        {
           "id":7,
           "start": new Date(year, month, day + 4, 18),
           "end": new Date(year, month, day + 6, 2),
           "type":"closed",
           "readOnly": true
        }
      ];
      events.map(convertTimesIn);
      return events;
   }
   
   function convertTimesIn(event) {
      event.start = new Date(event.start.getTime() - 7200000)
      event.end = new Date(event.end.getTime() - 7200000)
   }
   
   function convertTimesOut(event) {
      event.start = new Date(event.start.getTime() + 7200000)
      event.end = new Date(event.end.getTime() + 7200000)
   }

});
