-- Exercice 1 - Étape 5: Mettre à jour les procédures ETL pour inclure region_id
SET search_path = ecommerce_dwh_star;

-- Mettre à jour la procédure load_fact_sales pour inclure region_id
CREATE OR REPLACE PROCEDURE ecommerce_dwh_star.load_fact_sales()
  LANGUAGE plpgsql AS
$$
BEGIN
  INSERT INTO ecommerce_dwh_star.fact_sales
      (sale_key, sale_id, date_key, time_key, product_key,
       customer_key, quantity, total_amount, payment_method_key, region_id)
  SELECT nextval('seq_fact_sales_key')
       , (trim(s.sale_id))::INT
       , (TO_CHAR(parse_datetime(s.sale_date_time)::DATE, 'YYYYMMDD'))::INT AS date_key
       , (EXTRACT(HOUR FROM parse_datetime(s.sale_date_time)::TIME) * 10000
          + EXTRACT(MINUTE FROM parse_datetime(s.sale_date_time)::TIME) * 100
          + EXTRACT(SECOND FROM parse_datetime(s.sale_date_time)::TIME) * 1)::INT AS time_key
       , dp.product_key
       , dc.customer_key
       , (trim(s.quantity))::INT
       , (replace(replace(trim(s.total_amount), ' ', ''), ',', '.'))::NUMERIC(10, 2)
       , pm.payment_method_key
       , (trim(s.region_id))::INT  -- Nouvelle colonne region_id
  FROM raw.sales_raw s
  JOIN ecommerce_dwh_star.dim_product dp
    ON dp.product_id = (trim(s.product_id))::INT
  JOIN ecommerce_dwh_star.dim_customer dc
    ON dc.client_id = (trim(s.client_id))::INT
  LEFT JOIN raw.payment_history_raw ph
    ON trim(ph.sale_id) = trim(s.sale_id)
  LEFT JOIN ecommerce_dwh_star.dim_payment_method pm
    ON pm.method = upper(trim(ph.method))
  WHERE NOT EXISTS (
    SELECT 1
      FROM ecommerce_dwh_star.fact_sales tgt
     WHERE tgt.sale_id = (trim(s.sale_id))::INT
  );
END;
$$;