/*
package com.ATG.Timetable;

import java.sql.*;
import java.time.LocalTime;
import java.util.*;

public class TimetableGenerator {
    private static Connection conn = null;
    private static String program = "";
    private static String department = "";
    private static String semester = "";
    private final String section;
    private final List<String> days = Arrays.asList("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
    private final List<String> timeSlots;
    private final Map<String, Map<String, String>> timetable = new LinkedHashMap<>();
    private final Set<String> teacherSchedule = new HashSet<>();
    private final Set<String> sectionSchedule = new HashSet<>();

    public TimetableGenerator(Connection conn, String program, String department, String semester, String section) throws SQLException {
        TimetableGenerator.conn = conn;
        TimetableGenerator.program = program;
        TimetableGenerator.department = department;
        TimetableGenerator.semester = semester;
        this.section = section;
        this.timeSlots = fetchTimeSlots(conn,program,department,semester);
        initializeTimetable();
    }

    public static List<String> fetchTimeSlots(Connection conn, String program, String department, String semester) throws SQLException {
        List<String> slots = new ArrayList<>();
        String query = "SELECT startTime, endTime, classDuration, breakDuration FROM semesters WHERE programName = ? AND departmentName = ? AND semester = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, program);
            stmt.setString(2, department);
            stmt.setString(3, semester);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String startTime = rs.getString("startTime");
                    String endTime = rs.getString("endTime");
                    int slotDuration = rs.getInt("classDuration");
                    int breakDuration = rs.getInt("breakDuration");

                    LocalTime start = LocalTime.parse(startTime);
                    LocalTime end = LocalTime.parse(endTime);
                    int count = 0;

                    while (start.isBefore(end)) {
                        if (count == 3) {
                            LocalTime next = start.plusMinutes(breakDuration);
                            slots.add("break: " + start + "-" + next);
                            start = next;
                        }
                        LocalTime nextSlot = start.plusMinutes(slotDuration);
                        slots.add(start + " - " + (nextSlot.isAfter(end) ? end : nextSlot));
                        start = nextSlot;
                        count++;
                    }
                }
            }
        }
        return slots;
    }

    private void initializeTimetable() {
        for (String day : days) {
            timetable.put(day, new LinkedHashMap<>());
            for (String slot : timeSlots) {
                timetable.get(day).put(slot, null);
            }
        }
    }

    private List<Map<String, Object>> fetchSubjectTeacherAssignments() throws SQLException {
        List<Map<String, Object>> assignments = new ArrayList<>();
        String sql = "SELECT s.subjectName, t.teacherName, s.classesPerWeek, s.subjectType FROM assign a " +
                     "JOIN subjects s ON a.subjectName = s.subjectName " +
                     "JOIN teachers t ON a.teacherName = t.teacherName " +
                     "WHERE a.programName = ? AND a.departmentName = ? AND a.semester = ? AND a.section = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, program);
            stmt.setString(2, department);
            stmt.setString(3, semester);
            stmt.setString(4, section);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> assignment = new HashMap<>();
                    assignment.put("subjectName", rs.getString("subjectName"));
                    assignment.put("teacherName", rs.getString("teacherName"));
                    assignment.put("classesPerWeek", rs.getInt("classesPerWeek"));
                    assignment.put("type", rs.getString("subjectType"));
                    assignments.add(assignment);
                }
            }
        }
        return assignments;
    }

    public Map<String, Map<String, String>> generate() throws SQLException {
        List<Map<String, Object>> subjectTeachers = fetchSubjectTeacherAssignments();

        List<Map<String, Object>> labSubjects = new ArrayList<>();
        List<Map<String, Object>> theorySubjects = new ArrayList<>();
        for (Map<String, Object> st : subjectTeachers) {
            if ("Lab".equalsIgnoreCase((String) st.get("type"))) {
                labSubjects.add(st);
            } else {
                theorySubjects.add(st);
            }
        }

        for (Map<String, Object> lab : labSubjects) {
            allocateLabSlots(lab);
        }

        for (Map<String, Object> theory : theorySubjects) {
            allocateTheorySlots(theory);
        }

        return timetable;
    }


    private void allocateLabSlots(Map<String, Object> lab) {
        String subjectTeacher = lab.get("subjectName") + " - " + lab.get("teacherName");
        int totalSlots = (int) lab.get("classesPerWeek");
        int slotsPerSession = 3;  // You can set to 4 if needed per subject type
        int sessionsRequired = totalSlots / slotsPerSession;

        List<String> shuffledDays = new ArrayList<>(days);
        Collections.shuffle(shuffledDays);

        for (int s = 0; s < sessionsRequired; s++) {
            boolean sessionPlaced = false;
            for (String day : shuffledDays) {
                // Skip if this subject already has a lab scheduled today
                boolean alreadyScheduledToday = timetable.get(day).values().stream()
                        .anyMatch(value -> subjectTeacher.equals(value));
                if (alreadyScheduledToday) continue;

                for (int i = 0; i <= timeSlots.size() - slotsPerSession; i++) {
                    boolean validBlock = true;
                    List<String> blockSlots = new ArrayList<>();

                    for (int j = 0; j < slotsPerSession; j++) {
                        String slot = timeSlots.get(i + j);
                        String key = day + "-" + slot;

                        if (slot.contains("break") || 
                            timetable.get(day).get(slot) != null ||
                            teacherSchedule.contains(key) || 
                            sectionSchedule.contains(key)) {
                            validBlock = false;
                            break;
                        }

                        blockSlots.add(slot);
                    }

                    if (validBlock) {
                        for (String slot : blockSlots) {
                            String key = day + "-" + slot;
                            timetable.get(day).put(slot, subjectTeacher);
                            teacherSchedule.add(key);
                            sectionSchedule.add(key);
                        }
                        sessionPlaced = true;
                        break;
                    }
                }

                if (sessionPlaced) break;
            }

            if (!sessionPlaced) {
                System.out.println("Warning: Could not place lab session for " + subjectTeacher);
            }
        }
    }

    
    private void allocateTheorySlots(Map<String, Object> theory) {
        String subjectTeacher = theory.get("subjectName") + " - " + theory.get("teacherName");
        int classesPerWeek = (int) theory.get("classesPerWeek");

        // First pass: try to assign 2 slots per day max
        List<String> shuffledDays = new ArrayList<>(days);
        Collections.shuffle(shuffledDays);

        for (String day : shuffledDays) {
            if (classesPerWeek <= 0) break;

            List<String> shuffledSlots = new ArrayList<>(timeSlots);
            Collections.shuffle(shuffledSlots);
            int slotsAssignedToday = 0;

            for (String timeSlot : shuffledSlots) {
                if (classesPerWeek <= 0 || slotsAssignedToday >= 2) break;
                if (timeSlot.contains("break")) continue;

                String key = day + "-" + timeSlot;
                if (timetable.get(day).get(timeSlot) == null &&
                    !teacherSchedule.contains(key) &&
                    !sectionSchedule.contains(key)) {

                    timetable.get(day).put(timeSlot, subjectTeacher);
                    teacherSchedule.add(key);
                    sectionSchedule.add(key);
                    classesPerWeek--;
                    slotsAssignedToday++;
                }
            }
        }

        // Second pass: Fill any remaining classes in any valid free slot
        if (classesPerWeek > 0) {
            outer:
            for (String day : days) {
                for (String timeSlot : timeSlots) {
                    if (classesPerWeek <= 0) break outer;
                    if (timeSlot.contains("break")) continue;

                    String key = day + "-" + timeSlot;
                    if (timetable.get(day).get(timeSlot) == null &&
                        !teacherSchedule.contains(key) &&
                        !sectionSchedule.contains(key)) {

                        timetable.get(day).put(timeSlot, subjectTeacher);
                        teacherSchedule.add(key);
                        sectionSchedule.add(key);
                        classesPerWeek--;
                    }
                }
            }
        }

        if (classesPerWeek > 0) {
            System.out.println("⚠️ Could not assign all classes for: " + subjectTeacher + ". Remaining: " + classesPerWeek);
        }
    }
}
*/

package com.ATG.Timetable;

import java.sql.*;
import java.time.LocalTime;
import java.util.*;
//import java.util.stream.Collectors;

public class TimetableGenerator {
    private static Connection conn = null;
    private static String program = "";
    private static String department = "";
    private static String semester = "";
    private final String section;
    private final List<String> days = Arrays.asList("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday");
    private final List<String> timeSlots;
    private final Map<String, Map<String, String>> timetable = new LinkedHashMap<>();

    public TimetableGenerator(Connection conn, String program, String department, String semester, String section) throws SQLException {
        TimetableGenerator.conn = conn;
        TimetableGenerator.program = program;
        TimetableGenerator.department = department;
        TimetableGenerator.semester = semester;
        this.section = section;
        this.timeSlots = fetchTimeSlots(conn, program, department, semester);
        initializeTimetable();
    }

    public static List<String> fetchTimeSlots(Connection conn, String program, String department, String semester) throws SQLException {
        List<String> slots = new ArrayList<>();
        String query = "SELECT startTime, endTime, classDuration, breakDuration FROM semesters WHERE programName = ? AND departmentName = ? AND semester = ?";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, program);
            stmt.setString(2, department);
            stmt.setString(3, semester);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    String startTime = rs.getString("startTime");
                    String endTime = rs.getString("endTime");
                    int slotDuration = rs.getInt("classDuration");
                    int breakDuration = rs.getInt("breakDuration");

                    LocalTime start = LocalTime.parse(startTime);
                    LocalTime end = LocalTime.parse(endTime);
                    int count = 0;

                    while (start.isBefore(end)) {
                        if (count == 3) {
                            LocalTime next = start.plusMinutes(breakDuration);
                            slots.add("break: " + start + "-" + next);
                            start = next;
                        }
                        LocalTime nextSlot = start.plusMinutes(slotDuration);
                        slots.add(start + " - " + (nextSlot.isAfter(end) ? end : nextSlot));
                        start = nextSlot;
                        count++;
                    }
                }
            }
        }
        return slots;
    }

    private void initializeTimetable() {
        for (String day : days) {
            timetable.put(day, new LinkedHashMap<>());
            for (String slot : timeSlots) {
                timetable.get(day).put(slot, null);
            }
        }
    }

    private List<Map<String, Object>> fetchSubjectTeacherAssignments() throws SQLException {
        List<Map<String, Object>> assignments = new ArrayList<>();
        String sql = "SELECT s.subjectName, t.teacherName, s.classesPerWeek, s.subjectType FROM assign a " +
                "JOIN subjects s ON a.subjectName = s.subjectName " +
                "JOIN teachers t ON a.teacherName = t.teacherName " +
                "WHERE a.programName = ? AND a.departmentName = ? AND a.semester = ? AND a.section = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, program);
            stmt.setString(2, department);
            stmt.setString(3, semester);
            stmt.setString(4, section);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Map<String, Object> assignment = new HashMap<>();
                    assignment.put("subjectName", rs.getString("subjectName"));
                    assignment.put("teacherName", rs.getString("teacherName"));
                    assignment.put("classesPerWeek", rs.getInt("classesPerWeek"));
                    assignment.put("type", rs.getString("subjectType"));
                    assignments.add(assignment);
                }
            }
        }
        return assignments;
    }

    public Map<String, Map<String, String>> generate() throws SQLException {
        List<Map<String, Object>> subjectTeachers = fetchSubjectTeacherAssignments();

        List<Map<String, Object>> labSubjects = new ArrayList<>();
        List<Map<String, Object>> theorySubjects = new ArrayList<>();
        for (Map<String, Object> st : subjectTeachers) {
            if ("Lab".equalsIgnoreCase((String) st.get("type"))) {
                labSubjects.add(st);
            } else {
                theorySubjects.add(st);
            }
        }

        for (Map<String, Object> lab : labSubjects) {
            allocateLabSlots(lab);
        }

        for (Map<String, Object> theory : theorySubjects) {
            allocateTheorySlots(theory);
        }

        return timetable;
    }

    private boolean isGloballyOccupied(String day, String slot, String teacher, String subject, String type) throws SQLException {
        String sql = "SELECT 1 FROM global_schedule WHERE day = ? AND time_slot = ? AND teacher = ? AND subject = ? AND entity_type = ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, day);
            stmt.setString(2, slot);
            stmt.setString(3, teacher);
            stmt.setString(4, subject);
            stmt.setString(5, type);
            ResultSet rs = stmt.executeQuery();
            return rs.next();
        }
    }

    private void markGloballyOccupied(String day, String slot, String type, String teacher, String subject) throws SQLException {
        String sql = "INSERT INTO global_schedule(day, time_slot, entity_type, program, department, semester, section, subject, teacher) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, day);
            stmt.setString(2, slot);
            stmt.setString(3, type);
            stmt.setString(4, program);
            stmt.setString(5, department);
            stmt.setString(6, semester);
            stmt.setString(7, section);
            stmt.setString(8, subject);
            stmt.setString(9, teacher);
            stmt.executeUpdate();
        }
    }

    private void allocateLabSlots(Map<String, Object> lab) throws SQLException {
        String subject = (String) lab.get("subjectName");
        String teacher = (String) lab.get("teacherName");
        String subjectTeacher = subject + " - " + teacher;
        int totalSlots = (int) lab.get("classesPerWeek");

        // Get all booked lab slots for this subject-teacher
        Map<String, List<String>> bookedSlotsByDay = getBookedLabSlotsByDay(subject, teacher);
        int placedSlots = 0;

        for (String day : bookedSlotsByDay.keySet()) {
            List<String> slots = bookedSlotsByDay.get(day);
            Collections.sort(slots, Comparator.comparingInt(s -> timeSlots.indexOf(s))); // Sort slots as per timetable order

            for (String slot : slots) {
                if (timetable.get(day).get(slot) == null) {
                    timetable.get(day).put(slot, subjectTeacher);
                    //markGloballyOccupied(day, slot, "lab", teacher, subject);
                    placedSlots++;
                    if (placedSlots >= totalSlots) break;
                }
            }

            if (placedSlots >= totalSlots) break;
        }

        if (placedSlots < totalSlots) {
            System.out.println("⚠️ Not all booked lab slots could be allocated for " + subjectTeacher + ". Allocated: " + placedSlots);
        }
    }
    private Map<String, List<String>> getBookedLabSlotsByDay(String subject, String teacher) throws SQLException {
        Map<String, List<String>> result = new HashMap<>();

        String query = "SELECT day, time_slot FROM global_schedule WHERE subject = ? AND teacher = ? AND entity_type = 'lab'";
        try (PreparedStatement stmt = conn.prepareStatement(query)) {
            stmt.setString(1, subject);
            stmt.setString(2, teacher);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    String day = rs.getString("day");
                    String slot = rs.getString("time_slot");
                    result.computeIfAbsent(day, k -> new ArrayList<>()).add(slot);
                }
            }
        }

        return result;
    }


    private void allocateTheorySlots(Map<String, Object> theory) throws SQLException {
        String subject = (String) theory.get("subjectName");
        String teacher = (String) theory.get("teacherName");
        String subjectTeacher = subject + " - " + teacher;
        int classesPerWeek = (int) theory.get("classesPerWeek");

        List<String> shuffledDays = new ArrayList<>(days);
        Collections.shuffle(shuffledDays);

        for (String day : shuffledDays) {
            if (classesPerWeek <= 0) break;

            List<String> shuffledSlots = new ArrayList<>(timeSlots);
            Collections.shuffle(shuffledSlots);
            int slotsAssignedToday = 0;

            for (String slot : shuffledSlots) {
                if (classesPerWeek <= 0 || slotsAssignedToday >= 2) break;
                if (slot.contains("break")) continue;

                if (timetable.get(day).get(slot) == null &&
                    !isGloballyOccupied(day, slot, teacher, subject, "teacher")) {

                    timetable.get(day).put(slot, subjectTeacher);
                    markGloballyOccupied(day, slot,  "teacher", teacher, subject);
                    classesPerWeek--;
                    slotsAssignedToday++;
                }
            }
        }

        if (classesPerWeek > 0) {
            outer:
            for (String day : days) {
                for (String slot : timeSlots) {
                    if (classesPerWeek <= 0) break outer;
                    if (slot.contains("break")) continue;

                    if (timetable.get(day).get(slot) == null &&
                        !isGloballyOccupied(day, slot, teacher, subject, "teacher")) {

                        timetable.get(day).put(slot, subjectTeacher);
                        markGloballyOccupied(day, slot, "teacher",  teacher, subject);
                        classesPerWeek--;
                    }
                }
            }
        }

        if (classesPerWeek > 0) {
            System.out.println("⚠️ Could not assign all theory classes for: " + subjectTeacher + ". Remaining: " + classesPerWeek);
        }
    }
}
