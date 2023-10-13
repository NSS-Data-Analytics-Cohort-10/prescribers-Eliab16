1. 
  --  a. Which prescriber had the highest total number of claims (totaled over all drugs)? Report the npi and the total number of claims.
ans	  
	SELECT npi, sum(total_claim_count) AS total_drugs
	FROM prescriber
	INNER JOIN prescription
	USING(npi)
	GROUP BY (npi)
	order by total_drugs DESC
	LIMIT 1;
	
	ANS 99707
	
	
    
    --b. Repeat the above, but this time report the nppes_provider_first_name, nppes_provider_last_org_name,  specialty_description, and the total number of claims.
     
	 SELECT npi,nppes_provider_last_org_name,nppes_provider_first_name,specialty_description,SUM(total_claim_count) AS  
	 sum_total_claim
	 FROM 
	 prescriber
	 INNER JOIN prescription
	 USING(npi)
	 GROUP BY npi,nppes_provider_last_org_name,nppes_provider_first_name,specialty_description
	 ORDER BY sum_total_claim;
	 
-- 
2. 
    a. Which specialty had the most total number of claims (totaled over all drugs)?
	
	
-- 	ans 
	
	 SELECT specialty_description,sum(total_claim_count) AS total_claim_count
	FROM prescriber
	INNER JOIN prescription
	USING(npi)
	inner join drug 
	using (drug_name)
	GROUP BY specialty_description
	order by total_claim_count DESC;
	 ans 'Family practice'
	 
	 
	 
	 	
	
	
	
	

   -- b. Which specialty had the most total number of claims for opioids?	 
	 
	  SELECT specialty_description,opioid_drug_flag,sum(total_claim_count) AS total_claim_count
	FROM prescriber
	INNER JOIN prescription
	USING(npi)
	inner join drug 
	using (drug_name)
	GROUP BY specialty_description,opioid_drug_flag
	order by total_claim_count DESC;
	
-- 	ans 'Family Practice'
	
	  
	

   -- c. **Challenge Question:** Are there any specialties that appear in the prescriber table that have no associated prescriptions in the prescription table?

--     d. **Difficult Bonus:** *Do not attempt until you have solved all other problems!* For each specialty, report the percentage of total claims by that specialty which are for opioids. Which specialties have a high percentage of opioids?

3. 
   --- a. Which drug (generic_name) had the highest total drug cost?
	
	
	--ans
	
	  SELECT generic_name,sum(total_drug_cost)AS total_cost
	  FROM prescription
	  INNER JOIN drug
	  USING(drug_name)
	  GROUP BY generic_name,total_drug_cost
	  order by total_cost DESC
	  LIMIT 1;
	  
	  --'PIRFENIDONE'...... total_drug_cost------'2829174.3'
	  
	 
	  
	  

--     b. Which drug (generic_name) has the hightest total cost per day?
	**Bonus: Round your cost per day column to 2 decimal places. Google ROUND to see how this works.**
     
	 SELECT generic_name,total_drug_cost,total_day_supply,ROUND(total_drug_cost/total_day_supply,2) AS per_day_cost	
	  FROM prescription
	  INNER JOIN drug
	  USING(drug_name)
	  GROUP BY generic_name,total_drug_cost,total_day_supply,per_day_cost
	  order by per_day_cost DESC;
	  
	  --ans "IMMUN GLOB G(IGG)/GLY/IGA OV50".................per day cost '7141.11'
	   


	  
4. 
   --- a. For each drug in the drug table, return the drug name and then a column named 'drug_type' 
--    which says 'opioid' for drugs which have opioid_drug_flag = 'Y', 
-- says 'antibiotic' for those drugs which have antibiotic_drug_flag = 'Y', and says 'neither' for all other drugs.
  
     SELECT drug_name,
	 CASE 
		WHEN opioid_drug_flag = 'Y' THEN 'opioid'
		WHEN antibiotic_drug_flag ='Y' THEN 'antibiotic'
	 	ELSE 'neither'
	 END AS drug_type
	 FROM drug;
	 
	 
	 
	 
  
  
    ---b. Building off of the query you wrote for part a, determine whether more was spent (total_drug_cost) on opioids or on antibiotics.
	Hint: Format the total costs as MONEY for easier comparision.
	  
--ans

SELECT 
	CONCAT('$',FORMAT(SUM(CASE WHEN drug_name LIKE '%opioid%'
	THEN total_drug_cost ELSE 0 END),2)) AS opioid_cost,
	CONCAT('$',FORMAT(SUM(CASE WHEN drug_name LIKE '%antibiotics%'	
	THEN total_drug_cost ELSE 0 END),2)) AS antibiotic_cost
	FROM prescription
	INNER JOIN drug
	USING(drug_name)
	
	
	
	SELECT 
	CONCAT('$',FORMAT(SUM(CASE WHEN drug_name LIKE '%opioid%'
	THEN  sum(total_drug_cost) ELSE 0 END),2)) AS opioid_cost,
	CONCAT('$',FORMAT(SUM(CASE WHEN drug_name LIKE '%antibiotics%'	
	THEN sum(total_drug_cost) ELSE 0 END),2)) AS antibiotic_cost
	FROM prescription
	INNER JOIN drug
	USING(drug_name)
	
						  
       
	 
    
	
-- 5. 
--     a. How many CBSAs are in Tennessee? **Warning:**\
	The cbsa table contains information for all states, not just Tennessee.
	
		
	SELECT DISTINCT(cbsaname)
	FROM cbsa
	WHERE cbsaname LIKE '%TN%';
	
	---ans 10
	
	
	
	
	ANS '42'SELECT DISTINCT(cbsaname)
	FROM cbsa c
	LEFT JOIN fips_county f
	ON c.fipscounty=f.fipscounty
	WHERE state LIKE '%TN%'
	GROUP BY f.state;
	

	

--     b. Which cbsa has the largest combined population? Which has the smallest? 
	Report the CBSA name and total population.
	
	
	SELECT c.cbsa,c.cbsaname,sum(population) AS total_population
	FROM cbsa c
	INNER JOIN population
	USING(fipscounty)
	GROUP BY c.cbsa,c.cbsaname
	ORDER BY total_population DESC;
	
	--ans '28940' has largest combined population','862490' and CBSA name "Knoxville, TN"
	
	
	 	
	--  c. What is the largest (in terms of population) county which is not included in a CBSA?
	Report the county name and population.
	
	SELECT c.cbsa,c.cbsaname,sum(population) AS total_population,f.county
	FROM  cbsa c
	INNER JOIN fips_county f
	USING(fipscounty)
	INNER JOIN population p
	USING (fipscounty)
	WHERE cbsa IS NULL
	GROUP BY c.cbsa,c.cbsaname,f.county
	ORDER BY total_population DESC;
	
	
	
	--NOT FINISHED
	
	
		
--6	   -- a. Find all rows in the prescription table where total_claims is at least 3000.
	
	Report the drug_name and the total_claim_count.
	
	--ans

	SELECT drug_name, SUM(total_claim_count) AS total_clims
	FROM drug
	LEFT JOIN prescription 
	USING(drug_name)
	WHERE total_claim_count >= 3000
	GROUP BY drug_name;
	
	
	
	   
	   	

    b. For each instance that you found in part a, add a column that indicates whether the drug is an opioid.
	
	SELECT drug_name, SUM(total_claim_count) AS total_clims,
	CASE WHEN opioid_drug_flag='Y' THEN 'opioid'
	ELSE 'NO'
	END AS opioid
    FROM drug
	LEFT JOIN prescription 
	USING(drug_name)
	WHERE total_claim_count >= 3000
	GROUP BY drug_name,opioid_drug_flag;
	

   -- c. Add another column to you answer from the previous part which gives the prescriber first and last name associated with each row.
	
	
	SELECT  nppes_provider_first_name,nppes_provider_last_org_name,drug_name, SUM(total_claim_count) AS total_clims,
	CASE WHEN opioid_drug_flag='Y' THEN 'opioid'
     ELSE 'NO'
	END AS opioid
	FROM prescriber
	INNER JOIN prescription
	USING(npi)
	INNER JOIN drug
	USING(drug_name)
	
	WHERE total_claim_count >= 3000
	GROUP BY nppes_provider_first_name,nppes_provider_last_org_name,drug_name,opioid_drug_flag;
	
	

--7. The goal of this exercise is to generate a full list of all pain management specialists in Nashville
and the number of claims they had for each opioid. **Hint:** The results from all 3 parts will have 637 rows.

select*from cbsa
WHERE fipscounty=


    a. First, create a list of all npi/drug_name combinations for pain management specialists (specialty_description = 'Pain Management) in the city of Nashville (nppes_provider_city = 'NASHVILLE'), where the drug is an opioid (opiod_drug_flag = 'Y'). **Warning:** Double-check your query before running it. You will only need to use the prescriber and drug tables since you don't need the claims numbers yet.

    b. Next, report the number of claims per drug per prescriber. Be sure to include all combinations, whether or not the prescriber had any claims. You should report the npi, the drug name, and the number of claims (total_claim_count).
    
    c. Finally, if you have not done so already, fill in any missing values for total_claim_count with 0. Hint - Google the COALESCE function.