WITH SeasonalSales AS (
    SELECT
		month,
        dist_code,
        --fuel_type_petrol,
        CASE 
            WHEN MONTH(month) IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH(month) IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH(month) IN (6, 7, 8) THEN 'Summer'
            WHEN MONTH(month) IN (9, 10, 11) THEN 'Fall'
        END AS Season,
        SUM(fuel_type_petrol) AS total_petrol_sales,
		SUM(fuel_type_electric) AS total_eletric_sales,
		SUM(fuel_type_diesel) AS total_diesel_sales,
		SUM(fuel_type_others) AS total_others_sales,
		SUM(vehicleClass_MotorCycle) AS total_MotorCycle_Sales,
		SUM(vehicleClass_MotorCar) AS total_MotorCar_Sales,
		SUM(vehicleClass_AutoRickshaw) AS total_AutoRickshow_Sales,
		SUM(vehicleClass_Agriculture) AS total_Agriculture_Sales,
		SUM(vehicleClass_others) AS total_classothers_Sales,
		SUM(seatCapacity_1_to_3) AS total_capacity1_3_Sales,
		SUM(seatCapacity_4_to_6) AS total_capacity4_6_sales,
		SUM(seatCapacity_above_6) AS total_capacity6_above_sales,
		SUM(Brand_new_vehicles) AS total_Brandvehicles_Sales,
		SUM(Pre_owned_vehicles) AS total_PreOwned_Sales,
		SUM(category_Non_Transport ) AS total_nonTransport_Sales,
		SUM(category_Transport) AS total_transport_Sales

    FROM
        fact_transport
    GROUP BY
		month,
        dist_code,
       -- fuel_type_petrol,
		--month
		--Season
        CASE 
            WHEN MONTH(month) IN (12, 1, 2) THEN 'Winter'
            WHEN MONTH(month) IN (3, 4, 5) THEN 'Spring'
            WHEN MONTH(month) IN (6, 7, 8) THEN 'Summer'
            WHEN MONTH(month) IN (9, 10, 11) THEN 'Fall'
        END
)
SELECT
    dist_code,
	month,
    Season,
	CASE 
        WHEN total_MotorCycle_Sales > 0 THEN 'MotorCycle'
        WHEN total_MotorCar_Sales > 0 THEN 'MototrCar'
        WHEN total_AutoRickshow_Sales > 0 THEN 'AutoRickshow'
        WHEN total_Agriculture_Sales > 0 THEN 'Agriculture'
		WHEN total_classothers_Sales > 0 THEN 'otherClass'
        ELSE 'Unknown'
    END AS vehical_class,
	CASE 
        WHEN total_petrol_sales > 0 THEN 'Petrol'
        WHEN total_eletric_sales > 0 THEN 'Electric'
        WHEN total_diesel_sales > 0 THEN 'Diesel'
        WHEN total_others_sales > 0 THEN 'Others'
        ELSE 'Unknown'
    END AS fuel_type,
    total_petrol_sales,
	total_eletric_sales,
	total_diesel_sales,
	total_others_sales,
	total_MotorCycle_Sales,
	total_MotorCar_Sales,
	total_AutoRickshow_Sales,
	total_Agriculture_Sales,
	total_classothers_Sales,
	total_capacity1_3_Sales,
	total_capacity4_6_sales,
	total_capacity6_above_sales,
	total_Brandvehicles_Sales,
	total_PreOwned_Sales,
	total_nonTransport_Sales,
	total_transport_Sales



	
FROM
    SeasonalSales;



--select * from fact_transport