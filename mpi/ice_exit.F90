!=======================================================================
!
!BOP
!
! !MODULE: ice_exit - exit the model
!
! !DESCRIPTION:
!
! Exit the model. 
!
! !REVISION HISTORY:
!  SVN:$Id: ice_exit.F90 82 2007-10-02 15:44:25Z eclare $
!
! authors William H. Lipscomb (LANL)
!         Elizabeth C. Hunke (LANL)
! 2006 ECH: separated serial and mpi functionality
!
! !INTERFACE:
!
      module ice_exit
!
! !USES:
!
      use ice_kinds_mod
      use ifcore, Only : tracebackqq
!EOP
!
      implicit none

!=======================================================================

      contains

!=======================================================================
!BOP
!
! !ROUTINE: abort_ice - abort the model
!
! !INTERFACE:
!
      subroutine abort_ice(error_message)
!
! !DESCRIPTION:
!
!  This routine aborts the ice model and prints an error message.
!
! !REVISION HISTORY:
!
! same as module
!
! !USES:
!
      use ice_fileunits
      use ice_communicate
#if (defined CCSM) || (defined SEQ_MCT)
      use shr_sys_mod
#endif

      include 'mpif.h'   ! MPI Fortran include file
!
!
! !INPUT/OUTPUT PARAMETERS:
!
      character (len=*), intent(in) :: error_message
!
!EOP
!
      integer (int_kind) :: ierr ! MPI error flag
      ! MPI error flag, default to non-zero error
      integer (int_kind) :: errorcode = 1

#if (defined CCSM) || (defined SEQ_MCT)
      call shr_sys_abort(error_message)
#else
      call flush_fileunit(nu_diag)

      write (ice_stderr,*) error_message
      call flush_fileunit(ice_stderr)
      
#if defined(__INTEL_COMPILER)
      write (ice_stderr,*) "SPENCER INTEL COMPILER"
      call flush_fileunit(ice_stderr)
      call TRACEBACKQQ("SPENCER_TEST", -1)
#elif defined(__GFORTRAN__)
      write (ice_stderr,*) "SPENCER GFORTRAN"
      call flush_fileunit(ice_stderr)
      call BACKTRACE()
#endif

      call MPI_ABORT(MPI_COMM_WORLD, errorcode, ierr)
      stop
#endif

      end subroutine abort_ice

!=======================================================================
!BOP
!
! !IROUTINE: end_run - ends run
!
! !INTERFACE:
!
      subroutine end_run
!
! !DESCRIPTION:
!
! Ends run by calling MPI_FINALIZE.
!
! !REVISION HISTORY:
!
! author: ?
!
! !USES:
!
! !INPUT/OUTPUT PARAMETERS:
!

      integer (int_kind) :: ierr ! MPI error flag

      call MPI_FINALIZE(ierr)
!
!EOP
!
      end subroutine end_run

!=======================================================================

      end module ice_exit

!=======================================================================
