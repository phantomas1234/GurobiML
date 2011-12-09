/* Mathematic MathLink interface to Gurobi */

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "mathlink.h"
#include "gurobi_c.h"


void solveLPfromFile(char *path) {
  GRBenv   *masterenv = NULL;
  GRBmodel *model     = NULL;
  GRBenv   *modelenv  = NULL;
  int       error     = 0;
  int       optimstatus;
  int numVars;
  double    objval;
  double *sol;

  // if (argc < 2) {
  //   fprintf(stderr, "Usage: lp_c filename\n");
  //   exit(1);
  // }

  /* Create environment */

  error = GRBloadenv(&masterenv, "/tmp/gurobi_solve_from_file.log");
  if (error || masterenv == NULL) {
    fprintf(stderr, "Error: could not create environment\n");
    exit(1);
  }

  /* Read model from file */

  error = GRBreadmodel(masterenv, path, &model);
  if (error) goto QUIT;

  /* Solve model */

  error = GRBoptimize(model);
  if (error) goto QUIT;

  /* Capture solution information */

  error = GRBgetintattr(model, GRB_INT_ATTR_STATUS, &optimstatus);
  if (error) goto QUIT;

  /* If model is infeasible or unbounded, turn off presolve and resolve */

  if (optimstatus == GRB_INF_OR_UNBD) {
    modelenv = GRBgetenv(model);
    if (!modelenv) {
      // fprintf(stderr, "Error: could not get model environment\n");
      goto QUIT;
    }

    /* Change parameter on model environment.  The model now has
       a copy of the master environment, so changing the master will
       no longer affect the model.  */

    error = GRBsetintparam(modelenv, "PRESOLVE", 0);
    if (error) goto QUIT;

    error = GRBoptimize(model);
    if (error) goto QUIT;

    error = GRBgetintattr(model, GRB_INT_ATTR_STATUS, &optimstatus);
    if (error) goto QUIT;
  }

  if (optimstatus == GRB_OPTIMAL) {
    error = GRBgetdblattr(model, GRB_DBL_ATTR_OBJVAL, &objval);
    if (error) goto QUIT;
    
    error = GRBgetintattr(model, "NumVars", &numVars);
    sol = malloc(sizeof(double) * numVars);
    if (!sol) goto QUIT;
    
    error = GRBgetdblattrarray(model, GRB_DBL_ATTR_X, 0, numVars, sol);
    if (error) goto QUIT;
    
    MLPutFunction(stdlink, "List", 2);
      MLPutReal(stdlink, objval);
      MLPutRealList(stdlink, sol, numVars);
    
    // printf("Optimal objective: %.4e\n\n", objval);
  } else if (optimstatus == GRB_INFEASIBLE) {
    MLPutString(stdlink, (const char *) "Model is infeasible\n\n");

    // error = GRBcomputeIIS(model);
    // if (error) goto QUIT;

    // error = GRBwrite(model, "model.ilp");
    // if (error) goto QUIT;
  } else if (optimstatus == GRB_UNBOUNDED) {
    printf("Model is unbounded\n\n");
  } else {
    printf("Optimization was stopped with status = %d\n\n", optimstatus);
  }

QUIT:

  /* Error reporting */

  if (error) {
    // printf("ERROR: %s\n", GRBgeterrormsg(masterenv));
    MLPutString(stdlink, (const char *) GRBgeterrormsg(masterenv));
    // exit(1);
  }

  /* Free model */

  GRBfreemodel(model);

  /* Free environment */

  GRBfreeenv(masterenv);

    
  free(sol);
}

void solve(double *obj, long objlen, double *lb, long lblen, double *ub, long ublen, 
          int *cbeg, long cbegLen, int *cind, long cindLen, double *cval, long cvalLen, double *rhs, 
          long rhsLen, char *senses, char *vtype, int *qrow, long qrowlen, int *qcol, long qcollen,
          double *qval, long qvallen) {
  GRBenv   *env   = NULL;
  GRBmodel *model = NULL;
  int       error = 0;
  double    sol[objlen];
  int       optimstatus;
  double    objval;
  int       zero = 0;


  /* Create environment */

  error = GRBloadenv(&env, "/tmp/GurobiML.log");
  if (error || env == NULL) {
    MLPutString(stdlink, (const char *) "Error: could not create environment\n");
  }

  /* Create an empty model */

  error = GRBnewmodel(env, &model, "LPmodel", 0, NULL, NULL, NULL, NULL, NULL);
  if (error) goto QUIT;


  /* Add variables */

  if(lblen == 0)
  {
    lb = NULL;
  }
  if(ublen == 0)
  {
    ub = NULL;
  }


  if(vtype == "NULL")
  {
    vtype = NULL;
  }
  
  // error = GRBaddvars(model, objlen, 0, NULL, NULL, NULL, obj, lb, ub, vtype, NULL);
  error = GRBaddvars(model, objlen, 0, NULL, NULL, NULL, obj, lb, ub, NULL, NULL);
  if (error) goto QUIT;
  
  error = GRBupdatemodel(model);
  if (error) goto QUIT;
  
  // GRBwrite(model, "BlubBeforeConstr.lp");
  // if (error) goto QUIT;

  /* Add constraints */
  
  if(rhsLen == 0)
  {
    rhs = NULL;
  }
  // if(senses = "")
  // {
  //   senses = NULL;
  // }

  error = GRBaddconstrs(model, cbegLen, cvalLen, cbeg, cind, cval, senses, rhs, NULL /*Row IDs*/);
  if (error) goto QUIT;

  // error = GRBupdatemodel(model);
  // if (error) goto QUIT;

// /* Add quadratic terms */

  error = GRBaddqpterms(model, qvallen, qrow, qcol, qval);
  if (error) goto QUIT;

  error = GRBupdatemodel(model);
  if (error) goto QUIT;

  // GRBwrite(model, "/tmp/Blub.lp");
  // if (error) goto QUIT;

  // GRBwrite(model, "Blub.mps");
  // if (error) goto QUIT;


//   /* Optimize model */

  error = GRBoptimize(model);
  if (error) goto QUIT;

  error = GRBgetintattr(model, GRB_INT_ATTR_STATUS, &optimstatus);
  if (error) goto QUIT;

  // GRBwrite(model, "/tmp/Blub2.lp");
  // if (error) goto QUIT;
  
  // if (optimstatus == GRB_OPTIMAL) {
  if (1 == 1) {
    // error = GRBgetdblattr(model, GRB_DBL_ATTR_OBJVAL, &objval);
    // if (error) goto QUIT;

    error = GRBgetdblattrarray(model, GRB_DBL_ATTR_X, 0, objlen, sol);
      if (error) goto QUIT;    


    MLPutFunction(stdlink, "List", 2);
      MLPutReal(stdlink, objval);
      MLPutRealList(stdlink, sol, objlen);
    // MLPutRealList(stdlink, sol, objlen);
  } else if (optimstatus == GRB_INF_OR_UNBD) {
    MLPutString(stdlink, (const char *) "Model is infeasible or unbounded\n");
    error = GRBcomputeIIS(model);
    if (error) goto QUIT;

    error = GRBwrite(model, "/tmp/ilpDump.ilp");
    if (error) goto QUIT;
    
  } else if (optimstatus == GRB_INFEASIBLE) {
    MLPutString(stdlink, (const char *) "Model is infeasible\n");
    error = GRBcomputeIIS(model);
    if (error) goto QUIT;

    error = GRBwrite(model, "/tmp/ilpDump.ilp");
    if (error) goto QUIT;
    
  } else {
    MLPutFunction(stdlink, "List", 2);
      MLPutString(stdlink, (const char *) "Optimization was stopped early\n");
      MLPutInteger(stdlink, optimstatus);
    // error = GRBgetdblattr(model, GRB_DBL_ATTR_OBJVAL, &objval);
    // if (error) goto QUIT;
    // 
    // error = GRBgetdblattrarray(model, GRB_DBL_ATTR_X, 0, objlen, sol);
    // if (error) goto QUIT;
  }




// 
//   /* Write model to 'mip1.lp' */
// 
//   error = GRBwrite(model, "mip1.lp");
//   if (error) goto QUIT;
//   
//   /* Capture solution information */
// 
//   error = GRBgetintattr(model, GRB_INT_ATTR_STATUS, &optimstatus);
//   if (error) goto QUIT;
// 
//   error = GRBgetdblattr(model, GRB_DBL_ATTR_OBJVAL, &objval);
//   if (error) goto QUIT;
// 
//   error = GRBgetdblattrarray(model, GRB_DBL_ATTR_X, 0, 3, sol);
//   if (error) goto QUIT;
// 
//   printf("\nOptimization complete\n");
//   if (optimstatus == GRB_OPTIMAL) {
//     printf("Optimal objective: %.4e\n", objval);
// 
//     printf("  x=%.0f, y=%.0f, z=%.0f\n", sol[0], sol[1], sol[2]);
//   } else if (optimstatus == GRB_INF_OR_UNBD) {
//     printf("Model is infeasible or unbounded\n");
//   } else {
//     printf("Optimization was stopped early\n");
//   }
//   
// 


QUIT:

  /* Error reporting */

  if (error) {
    MLPutString(stdlink, (const char *) GRBgeterrormsg(env));
  }

  /* Free model */

  GRBfreemodel(model);

  /* Free environment */

  GRBfreeenv(env);

}

int main(int argc, char *argv[]) {
   return MLMain(argc, argv);
}

    // int clen;
    // double *c;
    // 
    // MLGetReal64List(stdlink, &c, &clen);
    // 
    // double *mat;
    // long *matdim;
    // long matdepth;
    // 
    // MLGetDoubleArray(stdlink, &mat, &matdim, NULL, &matdepth);
    // 
    // MLPutReal64List(stdlink, c, clen);
    // 
    // 
    // 
    // MLPutFunction(stdlink, "List", 1);
    //     MLPutRealList(c, clen);