function newMvpc_scriptGenerator_searchlight_rev_fv(nSubjects,scriptDir,mvpcDir,parameters)

nNodes = ceil(nSubjects/parameters.slurm.cores_per_node);

for iNode = 1:nNodes

%% Parallel file

nTasks = min(parameters.slurm.cores_per_node,nSubjects-(iNode-1)*parameters.slurm.cores_per_node);

cd(scriptDir);
fid = fopen(sprintf('sbatch_newMvpc_parallel_searchlight_rev_fv_%d.sh',iNode),'wt');

fprintf(fid,'#!/bin/bash\n');
fprintf(fid,'#SBATCH --job-name=%s\n', parameters.slurm.name);  % Project Name
fprintf(fid,'#SBATCH --nodes=%d --cpus-per-task=%d  --tasks-per-node=%d\n', 1, parameters.slurm.cpus_per_task, nTasks);
fprintf(fid,'#SBATCH --mem-per-cpu=%d\n', parameters.slurm.mem_per_cpu);
fprintf(fid,'#SBATCH --time=%d-00:00:00\n', parameters.slurm.time);
fprintf(fid,'#SBATCH --mail-user=%s --mail-type=ALL\n', parameters.slurm.email);
fprintf(fid,'#SBATCH --output=../sbatch_%s_stdout_%d.txt\n', parameters.slurm.name,iNode);
fprintf(fid,'#SBATCH --error=../sbatch_%s_stderr_%d.txt\n', parameters.slurm.name,iNode);
fprintf(fid,'\n');
fprintf(fid,'module add openmpi/gcc/64/1.8.1\n');
fprintf(fid,'module add mit/matlab/2015a\n');
fprintf(fid,'cd %s\n',scriptDir);
fprintf(fid,'\n');
fprintf(fid,'chmod +x sbatch_newMvpc_single_searchlight_rev_fv_%d.sh\n',iNode);
fprintf(fid,'mpiexec -n %d ./sbatch_newMvpc_single_searchlight_rev_fv_%d.sh',nTasks,iNode);

fclose(fid);


%% Single file

cd(scriptDir);
fid = fopen(sprintf('sbatch_newMvpc_single_searchlight_rev_fv_%d.sh',iNode),'wt');
    
fprintf(fid,'#!/bin/bash\n');
fprintf(fid,'\n');
fprintf(fid,['file_num=sbatch_newMvpc_searchlight_rev_fv_$(printf ' char(34) '%s' char(34) ' $(($OMPI_COMM_WORLD_RANK + 1 + %d)))\n'],'%03d',(iNode-1)*parameters.slurm.cores_per_node);
fprintf(fid,['matlab -nodisplay -nosplash -singleCompThread -r ' char(34) '$file_num' char(34) '\n']);
fprintf(fid,'exit\n');
fprintf(fid,'\n');

fclose(fid);

end

%% MATLAB scripts

cd(scriptDir);
for iSubject = 1:nSubjects
        scriptName = sprintf('sbatch_newMvpc_searchlight_rev_fv_%03d.m',iSubject);
        fid = fopen(scriptName,'wt');
        fprintf(fid,'function  %s',scriptName(1:end-2));
        fprintf(fid,'\n cd(''%s'')', mvpcDir);
        fprintf(fid,'\n runSearchlight_viewpoint_rev_fv(%d)',iSubject);
        fclose(fid);
end


