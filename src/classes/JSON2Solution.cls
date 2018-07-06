global class JSON2Solution {
    public Data data;
    public class Details {
        public List<String> sol_stat;
        public List<String> sol_dist;
        public List<String> sol_os;
        public List<String> sol_apar;
        public List<String> title;
        public List<String> product;
        public List<String> release;
        public List<String> solution_number;
        public List<String> upd_date_time;
        
    }

    public class JSON2Sol {
        public Data data;
    }

    public class Data {
        public Integer httpStatusCode;
        public List<Details> details;
    }

    
    public static JSON2Solution parse(String json) {
        return (JSON2Solution ) System.JSON.deserialize(json, JSON2Solution.class);
    }
}