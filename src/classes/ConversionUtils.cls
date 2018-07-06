global class ConversionUtils {

    global static final Double KILOMETERS_IN_ONE_MILE  = 1.609344;

    global static Double convert(Double distance, UnitOfLength unit, UnitOfLength convertTo){
        if(distance == null){
            distance = 0;
        }
        Double conversion = 1;
        if(unit == UnitOfLength.KILOMETERS && convertTo == UnitOfLength.MILES){
            conversion = 1/KILOMETERS_IN_ONE_MILE;
        } else if(unit == UnitOfLength.MILES && convertTo == UnitOfLength.KILOMETERS){
            conversion = KILOMETERS_IN_ONE_MILE;
//        } else {
//            throw new IllegalArgumentException('invalid unit: ' + unit);
        }
        return distance * conversion;
    }

}