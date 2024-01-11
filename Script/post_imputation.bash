#bash post_imputation.bash <famfile location> <dataset name>
#example: bash post_imputation.bash  /path/to/fam/file/ad_c1_2_g37.fam ad_c1_2
#upload update_name.py to the imputation results home folder
set -e

famfile=$1
datasetname=$2

echo $datasetname post imputation start

for ((chr=1; chr<=22; chr++))
do
echo chr$chr start

cd chr$chr


plink2 --vcf chr${chr}.dose.vcf.gz --allow-extra-chr --make-bed --out chr${chr}_temp1.dose 


grep 'INS\|CN' chr${chr}_temp1.dose.bim > chr${chr}_INS_CN.list
plink2 --bfile chr${chr}_temp1.dose --fam ${famfile} --exclude chr${chr}_INS_CN.list --make-bed --out chr${chr}_temp2.dose

python ../update_name_v2_yl.py -i chr${chr}_temp2.dose.bim

plink2 --bfile chr${chr}_temp2.dose --allow-extra-chr --rm-dup force-first --make-bed --out chr${chr}.dose

rm *temp*
echo chr$chr done
cd ..

done

cd merge
plink --bfile ../chr22/chr22.dose --merge-list mergelist_post_imputation.txt --make-bed --out $datasetname.allchr.dose
plink --bfile $datasetname.allchr.dose --maf 0.01 --hwe 1e-6 --geno 0.01 --mind 0.01 --write-snplist --make-just-fam --out $datasetname.allchr.writesnp
plink --bfile $datasetname.allchr.dose --extract $datasetname.allchr.writesnp.snplist  --make-bed  --out $datasetname.allchr.dose.QC


