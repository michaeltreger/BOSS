$(document).ready(function() {

   String.prototype.hashCode = function(){
    var hash = 0;
    if (this.length == 0) return hash;
    for (i = 0; i < this.length; i++) {
        char = this.charCodeAt(i);
        hash = (127*hash + char) %16908799
        hash = hash & hash; // Convert to 32bit integer
    }
    return hash;
  }

   var $calendar = $('#calendar');
   var id = 999999999;
   var $events;
   
   $('#submit_calendar').bind('click', submit);
   $('#validate_calendar').bind('click', showValidateDialog);
   
   function submit() {
      if (validate()) {
        finalizedEvents = $calendar.weekCalendar("serializeAllEvents");
        json = JSON.stringify(finalizedEvents);
        //alert(json);
        $.ajax({
          type: "PUT",
          url: window.location.pathname+".json",
          data: {"calendar_updates": json},
          dataType: "jsonp",
          success: function(data, textStatus, XMLHttpRequest){
             alert("Succeeded");
          },
          error: function(data, textStatus, XMLHttpRequest){
             if (data.status == 200) {
               alert("Saved");
             } else {
               alert("Invalid");
             }
          }
        });
      } else {
        showValidateDialog();
      }
   }
   
   function validate() {
     finalizedEvents = $calendar.weekCalendar("serializeAllEvents");
     total_unavail = 0;
     weekday_unavail = 0;
     $.each(finalizedEvents, function (i, event) {
      if (event.entry_type === "class" || event.entry_type === "obligation"|| event.entry_type === "closed") {
         d = duration(event);
         if (d>0){
           if(event.start_time.getDay() != 0 && event.start_time.getDay() != 6) {
              weekday_unavail += d;
           }
           total_unavail += d
         }
      }
     });
 
     total_avail = 24*7 - total_unavail;
     weekday_avail = 24*5 - weekday_unavail;

     numberSatisfied = 0;
     option1 = "Failed";
     if (total_avail > 45 && weekday_avail > 15) {
       option1 = "Satisfied";
       numberSatisfied += 1;
     }
     option2 = "Failed";
     if (total_avail > 30) {
       option2 = "Satisfied";
       numberSatisfied += 1;
     }
     option3 = "Failed";
     if (weekday_avail > 25) {
       option3 = "Satisfied";
       numberSatisfied += 1;
     }

     $('.validate_total').html(total_avail);
     $('.validate_weekday').html(weekday_avail);
     $('#option1_status').html(option1);
     $('#option2_status').html(option2);
     $('#option3_status').html(option3);

     if (numberSatisfied < 2) {
       return false;
     } else {
        return true
     }
   }
   
   function showValidateDialog() {
     status = "Failed Validation";
     if (validate()) {
        status = "Passed";
     }
     validateDialog = $("#validate_container");
     validateDialog.dialog({
       modal: true,
       title: status,
       close: function() {
          validateDialog.dialog("destroy");
          validateDialog.hide();
       },
       buttons: {
          ok : function() {
             validateDialog.dialog("close");
          }
       }
     }).show();
   }
   
   function duration(event) {
      return (event.end_time - event.start_time)/3600000
   }
   
   getEventData();
   
   function getEventData() {   
      $.ajax({
         type: "GET",
         url: window.location.pathname+".json",
         dataType: "json",
         success: function(data) {
            events = data.events;
            $events = events;
            $readOnly = data.readOnly;
            $start_date = Date.parse(data.start_date);
            $end_date = Date.parse(data.end_date);
            $isLabCalendar = data.isLabCalendar;
            startCalendar();
         }
      });
   }
   
   function randomColor(initials) {
      letters = '0123456789ABCDEF'.split('');
      color = '#';
      seed = initials.hashCode();
      for (i = 0; i < 6; i++ ) {
          color += letters[(seed*i*3)%16]
      }
      return color;
   }
   
   function startCalendar() {
     $calendar.weekCalendar({
        timeslotHeight: 15,
        switchDisplay: {'1 day': 1, '3 next days': 3, 'work week': 5, 'full week': 7},
        minDate: $start_date,
        maxDate: $end_date,
        allowEventCreation: !$readOnly,
        displayOddEven:true,
        timeslotsPerHour : 2,
        allowCalEventOverlap : $isLabCalendar,
        overlapEventsSeparate: true,
        firstDayOfWeek : 1,
        businessHours :{start_time: 0, end_time: 24, limitDisplay: true },
        daysToShow : 7,
        title: function(daysToShow) {
           return daysToShow == 1 ? '%date%' : '%start% - %end%';
        },
        height : function($calendar) {
           return 15*24*2+100;//$(window).height() - $("h1").outerHeight() - 1;
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
           } else if (calEvent.entry_type=== "") {
              color = randomColor(calEvent.description);
              $event.css("backgroundColor", color);
              $event.find(".wc-time").css({
                 "backgroundColor" : color,
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
           currentType = $('input[name=entry_type_select]:checked').val();
           calEvent.entry_type = currentType;
           if (currentType == 'obligation') {
              var $dialogContent = $("#event_edit_container");
              resetForm($dialogContent);
              var startField = $dialogContent.find("select[name='start']").val(calEvent.start_time);
              var endField = $dialogContent.find("select[name='end']").val(calEvent.end_time);
              var entry_typeField = $dialogContent.find("select[name='entry_type']").val(calEvent.entry_type);
              var descriptionField = $dialogContent.find("textarea[name='description']");

              setDescriptionVisibility();

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
                       if (calEvent.entry_type === "obligation" && calEvent.description === "") {
                         document.getElementById("description_label").innerHTML = "Description (Required)";
                         document.getElementById("description_label").css("backgroundColor", "#f23");
                       } else {
                         $calendar.weekCalendar("updateEvent", calEvent);
                         $dialogContent.dialog("close");
                       }

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
           } else {
              calEvent.id = id;
              id++;
              $calendar.weekCalendar("removeUnsavedEvents");
              $calendar.weekCalendar("updateEvent", calEvent);
           }
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
                    
                    if (calEvent.entry_type === "obligation" && calEvent.description === "") {
                      document.getElementById("description_label").innerHTML = "Description (Required)";
                    } else {
                      $calendar.weekCalendar("updateEvent", calEvent);
                      $dialogContent.dialog("close");
                    }
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
      document.getElementById("description_label").innerHTML = "Description";
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
