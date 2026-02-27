import { useCallback } from 'react'
import type { Facility } from '@/types/facility'

export function useClinicFilter(allClinics: Facility[]) {
  const applyFilters = useCallback((
    prefectures: string[],
    genres: number[],
    ranking: string
  ): Facility[] => {
    let filtered = allClinics

    if (prefectures.length > 0) {
      filtered = filtered.filter(clinic => clinic.prefecture?.name && prefectures.includes(clinic.prefecture.name))
    }

    if (genres.length > 0) {
      filtered = filtered.filter(clinic => {
        // Check if the facility has ALL selected genres (AND condition)
        const facilityGenreIds = clinic.genres?.map(g => g.id) || []
        if (facilityGenreIds.length > 0) {
          return genres.every(genreId => facilityGenreIds.includes(genreId))
        }
        // Fall back to single genre_id if genres array is not available
        return genres.length === 1 && clinic.genre_id === genres[0]
      })
    }

    if (ranking) {
      const topCount = parseInt(ranking.replace('トップ', ''))
      const sortedByRating = [...filtered].sort((a, b) => {
        const scoreA = (a.star !== null && a.star > 0 && a.user_review_count > 0)
          ? a.star * a.user_review_count
          : 0
        const scoreB = (b.star !== null && b.star > 0 && b.user_review_count > 0)
          ? b.star * b.user_review_count
          : 0
        return scoreB - scoreA
      })
      filtered = sortedByRating.slice(0, topCount)
    }

    return filtered
  }, [allClinics])

  return { applyFilters }
}
