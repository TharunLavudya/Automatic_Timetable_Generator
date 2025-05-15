// Fetch departments when program is selected
       document.getElementById("programName").addEventListener("change", function () {
           const program = this.value;
           const departmentDropdown = document.getElementById("departmentName");

           departmentDropdown.innerHTML = '<option value="" disabled selected>Loading...</option>';

           fetch('../SubjectsServlet?action=getDepartments&program=' + encodeURIComponent(program))
               .then(response => response.json())
               .then(data => {
                   if (data.success) {
                       departmentDropdown.innerHTML = '<option value="" disabled selected>Select a Department</option>';
                       data.departments.forEach(dept => {
                           const option = document.createElement("option");
                           option.value = dept;
                           option.textContent = dept;
                           departmentDropdown.appendChild(option);
                       });
                   } else {
                       departmentDropdown.innerHTML = '<option value="" disabled selected>No departments available</option>';
                   }
               })
               .catch(error => {
                   departmentDropdown.innerHTML = '<option value="" disabled selected>Error loading departments</option>';
                   console.error("Error fetching departments:", error);
               });
       });

       // Fetch semesters when department is selected
       document.getElementById("departmentName").addEventListener("change", function () {
           const department = this.value;
           const program = document.getElementById("programName").value; 
           const semesterDropdown = document.getElementById("semester");

           semesterDropdown.innerHTML = '<option value="" disabled selected>Loading...</option>';

           fetch('../SubjectsServlet?action=getSemesters&program=' + encodeURIComponent(program) + '&department=' + encodeURIComponent(department))
               .then(response => response.json())
               .then(data => {
                   if (data.success) {
                       semesterDropdown.innerHTML = '<option value="" disabled selected>Select a Semester</option>';
                       data.semesters.forEach(sem => {
                           const option = document.createElement("option");
                           option.value = sem;
                           option.textContent = sem;
                           semesterDropdown.appendChild(option);
                       });
                   } else {
                       semesterDropdown.innerHTML = '<option value="" disabled selected>No semesters available</option>';
                   }
               })
               .catch(error => {
                   semesterDropdown.innerHTML = '<option value="" disabled selected>Error loading semesters</option>';
                   console.error("Error fetching semesters:", error);
               });
       });

       // Fetch sections when semester is selected
       document.getElementById("semester").addEventListener("change", function () {
           const semester = this.value;
           const program = document.getElementById("programName").value;
           const department = document.getElementById("departmentName").value;
           const sectionDropdown = document.getElementById("section");

           sectionDropdown.innerHTML = '<option value="" disabled selected>Loading...</option>';

           fetch('../AssignServlet?action=getSection&program=' + encodeURIComponent(program) + 
                 '&department=' + encodeURIComponent(department) + 
                 '&semester=' + encodeURIComponent(semester))
               .then(response => response.json())
               .then(data => {
                   if (data.success) {
                       sectionDropdown.innerHTML = '<option value="" disabled selected>Select a Section</option>';
                       let c = 'A';
                       while (data.sections-- > 0) {
                           const option = document.createElement("option");
                           option.value = c;
                           option.textContent = c;
                           sectionDropdown.appendChild(option);
                           c = String.fromCharCode(c.charCodeAt(0) + 1); 
                       }
                   } else {
                       sectionDropdown.innerHTML = '<option value="" disabled selected>No sections available</option>';
                   }
               })
               .catch(error => {
                   sectionDropdown.innerHTML = '<option value="" disabled selected>Error loading sections</option>';
                   console.error("Error fetching sections:", error);
               });
       });

       // Generate timetable on button click
       document.getElementById("viewButton").addEventListener("click", function () {
           const program = document.getElementById("programName").value;
           const department = document.getElementById("departmentName").value;
           const semester = document.getElementById("semester").value;
           const section = document.getElementById("section").value;

           fetch('../TimeTableServlet?action=getTimeSlots&program=' + encodeURIComponent(program) +
                 '&department=' + encodeURIComponent(department) + '&semester=' + encodeURIComponent(semester))
               .then(response => response.json())
               .then(data => {
                   if (data.success) {
                       const timeSlots = data.timeSlots;
                       populateTimetable(timeSlots, program, department, semester, section);
                   } else {
                       console.error("Error fetching time slots:", data.message);
                   }
               })
               .catch(error => {
                   console.error("Error fetching time slots:", error);
               });
       });

       // Populate the timetable dynamically
       function populateTimetable(timeSlots, program, department, semester, section) {
       	if (!program || !department || !semester || !section) {
       	    alert("Please select all required fields!");
       	    return;
       	}
		    // Create the data payload
			const timetableTable = document.getElementById("timetable");
			           timetableTable.innerHTML = ""; // Clear existing rows

			           // Create timetable header
			           const headerRow = document.createElement("tr");
			           const days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
			           const timeHeader = document.createElement("th");
			           timeHeader.textContent = "Days/Slots";
			           headerRow.appendChild(timeHeader); // Empty cell for times
			           timeSlots.forEach(slot => {
			               const th = document.createElement("th");
			               th.textContent = slot;
			               headerRow.appendChild(th);
			           });
			           timetableTable.appendChild(headerRow);

					   fetch('../TimeTableServlet?action=getTable&program=' + encodeURIComponent(program) +
					                    '&department=' + encodeURIComponent(department) + '&semester=' + encodeURIComponent(semester) + 
					                    '&section=' + encodeURIComponent(section))
					                  .then(response => response.json())
					                  .then(data => {
					                      if (data.success) {
					                          const timetableData = data.timetable; // { day: { timeslot: "subject-teacher" } }
					   					   
					   					  
					                          // Populate timetable rows
					                          days.forEach(day => {
					                              const row = document.createElement("tr");
					                              const dayCell = document.createElement("td");
					                              dayCell.textContent = day; // Day name`
					                              row.appendChild(dayCell);

					   						   timeSlots.forEach(slot => {
					   						       const cell = document.createElement("td");
					   						       // Check if the day exists in timetableData and if the slot exists
					   						       const subjectTeacher = timetableData[day] && timetableData[day][slot] ? timetableData[day][slot] : " ";
					   						       cell.textContent = subjectTeacher;
					   						       row.appendChild(cell);
					   						   });


					                              timetableTable.appendChild(row);
					                          });
					                      } else {
					                          alert("Failed to load timetable!");
					                      }
					                  })
					                  .catch(error => {
					                      console.error("Error loading timetable:", error);
					                      alert(error);
					                  });
		}
		
		setTimeout(function() {
		        document.getElementById("error-msg").style.display = "none";
		    }, 3000);

	  