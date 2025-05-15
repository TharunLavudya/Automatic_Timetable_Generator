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




document.getElementById("viewButton").addEventListener("click", function () {
    const program = document.getElementById("program").value;
    const department = document.getElementById("department").value;
    const semester = document.getElementById("semester").value;
    const section = document.getElementById("section").value;

    if (!program || !department || !semester || !section) {
        alert("Please fill all the fields!");
        return;
    }

    // Fetch the timetable from the backend
    fetch(`../TimetableServlet?action=getTable&program=${encodeURIComponent(program)}&department=${encodeURIComponent(department)}&semester=${encodeURIComponent(semester)}&section=${encodeURIComponent(section)}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                const timetableData = data.timetable;
                populateTimetable(timetableData);
            } else {
                alert("Failed to fetch timetable.");
            }
        })
        .catch(error => {
            console.error("Error fetching timetable:", error);
            alert("An error occurred while fetching the timetable.");
        });
});

function populateTimetable(timetableData) {
    const timetableTable = document.getElementById("timetable");
    timetableTable.innerHTML = ""; // Clear existing content

    const days = ["Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];
    const timeSlots = Object.keys(timetableData[days[0]]); // Assume all days have the same slots

    // Create the header row
    const headerRow = document.createElement("tr");
    const dayHeader = document.createElement("th");
    dayHeader.textContent = "Days/Time";
    headerRow.appendChild(dayHeader);

    timeSlots.forEach(slot => {
        const th = document.createElement("th");
        th.textContent = slot;
        headerRow.appendChild(th);
    });

    timetableTable.appendChild(headerRow);

    // Create rows for each day
    days.forEach(day => {
        const row = document.createElement("tr");
        const dayCell = document.createElement("td");
        dayCell.textContent = day;
        row.appendChild(dayCell);

        timeSlots.forEach(slot => {
            const cell = document.createElement("td");
            cell.textContent = timetableData[day][slot] || "Free";
            row.appendChild(cell);
        });

        timetableTable.appendChild(row);
    });
}
